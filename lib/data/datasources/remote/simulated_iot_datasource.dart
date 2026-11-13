import 'dart:math';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/panel_fault.dart';
import '../../../domain/entities/panel_reading.dart';
import 'iot_device_datasource.dart';
import '../../../core/utils/extensions.dart';

/// Physics-inspired simulator of the real IoT solar device.
///
/// Every plate gets its own device id; the simulator models:
///  * solar irradiance curve (day/night, clouds, Demo Sun override)
///  * cell temperature vs ambient + irradiance
///  * temperature derating of output power
///  * the full catalogue of faults with realistic electrical symptoms
///  * random fault injection so alerts can be demonstrated live
class SimulatedIotDatasource implements IotDeviceDatasource {
  SimulatedIotDatasource({this.randomFaultChance = 0.0035});

  final Random _random = Random();
  final Map<String, PanelFaultType> _faults = {};
  final Map<String, double> _cloudFactors = {};

  /// Chance per reading that a random fault occurs (demo pacing).
  final double randomFaultChance;

  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  Future<void> connect() async {
    _connected = true;
    AppLogger.i('IoTSim', 'Hub connected (${_faults.length} known faults kept)');
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    AppLogger.i('IoTSim', 'Hub disconnected');
  }

  @override
  Future<PanelReading?> readPanel(IotReadingRequest request) async {
    if (!_connected) return null;

    // Connection loss fault -> device silent.
    final PanelFaultType fault = activeFaultOf(request.deviceId);
    if (fault == PanelFaultType.connectionLoss) return null;

    // Cloud cover random walk per device (0.72..1.0).
    final double prev = _cloudFactors[request.deviceId] ?? 0.9;
    double cloud = prev + (_random.nextDouble() - 0.5) * 0.08;
    cloud = cloud.clampRange(0.72, 1.0);
    _cloudFactors[request.deviceId] = cloud;

    // Sometimes roll a brand new random fault.
    if (!fault.isActive && _random.nextDouble() < randomFaultChance) {
      final PanelFaultType newFault =
          _randomFaults[_random.nextInt(_randomFaults.length)];
      injectFault(request.deviceId, newFault);
      AppLogger.i('IoTSim', 'Random fault $newFault on ${request.deviceId}');
    }

    final double sunBase =
        AppDateTimeUtils.solarFactor(forceSunlight: request.forceSunlight);
    final double sun = sunBase * cloud;

    // Night — plate idle.
    if (sun <= 0.02) {
      return PanelReading(
        timestamp: DateTime.now(),
        voltage: 0.4 + _random.nextDouble() * 0.6,
        current: 0,
        power: 0,
        temperature: 20 + _random.nextDouble() * 6,
        irradiance: sun * 1000,
        efficiency: 0,
      );
    }

    // Cell temperature model + fault thermal effects.
    double cellTemp = 23 + sun * 34 + (_random.nextDouble() * 4 - 2);
    // Voltage model (typical 500-600W class Vmp ~ 40-42V).
    double voltage = 40.5 * (0.88 + 0.24 * sun) + (_random.nextDouble() - 0.5);
    // Power model with temperature derating (-0.38%/°C above 25°C).
    double power =
        request.ratedWatts * sun * 0.97 * (1 - 0.0038 * (cellTemp - 25));
    double current = voltage > 1 ? power / voltage : 0;

    switch (fault) {
      case PanelFaultType.none:
        break;
      case PanelFaultType.hotspot:
        cellTemp += 20 + _random.nextDouble() * 6;
        power *= 0.84;
        break;
      case PanelFaultType.openCircuit:
        power = 0;
        current = 0;
        voltage *= 1.06; // Voc slightly above Vmp
        break;
      case PanelFaultType.soiling:
        power *= 0.60;
        break;
      case PanelFaultType.partialShading:
        power *= 0.42 + _random.nextDouble() * 0.08;
        break;
      case PanelFaultType.microCrack:
        power *= 0.74;
        break;
      case PanelFaultType.bypassDiodeFailure:
        power *= 0.55;
        cellTemp += 7;
        break;
      case PanelFaultType.inverterFault:
        power = 0;
        current = 0;
        break;
      case PanelFaultType.overTemperature:
        cellTemp += 26;
        power *= 0.80;
        break;
      case PanelFaultType.underPerformance:
        power *= 0.48;
        break;
      case PanelFaultType.connectionLoss:
        return null;
      case PanelFaultType.stringFailure:
        power *= 0.33;
        break;
    }

    current = voltage > 1 ? power / voltage : 0;

    // Efficiency relative to expected output right now.
    final double expected = request.ratedWatts * sun * 0.95;
    final double efficiency =
        expected > 5 ? (power / expected * 100).clampRange(0, 100) : 100;

    return PanelReading(
      timestamp: DateTime.now(),
      voltage: voltage,
      current: current,
      power: power,
      temperature: cellTemp,
      irradiance: sun * 1000,
      efficiency: efficiency,
    );
  }

  @override
  Future<void> sendPowerCommand(String deviceId, bool on) async {
    // A real hub would publish an MQTT command; the simulator just logs.
    AppLogger.i('IoTSim', 'Power command $on -> $deviceId');
    await Future<void>.delayed(const Duration(milliseconds: 120));
  }

  @override
  PanelFaultType activeFaultOf(String deviceId) =>
      _faults[deviceId] ?? PanelFaultType.none;

  @override
  void injectFault(String deviceId, PanelFaultType fault) {
    _faults[deviceId] = fault;
  }

  @override
  void clearFault(String deviceId) {
    _faults.remove(deviceId);
  }

  @override
  void clearAllFaults() {
    _faults.clear();
  }

  static const List<PanelFaultType> _randomFaults = [
    PanelFaultType.hotspot,
    PanelFaultType.soiling,
    PanelFaultType.partialShading,
    PanelFaultType.microCrack,
    PanelFaultType.bypassDiodeFailure,
    PanelFaultType.underPerformance,
    PanelFaultType.openCircuit,
    PanelFaultType.stringFailure,
  ];
}
