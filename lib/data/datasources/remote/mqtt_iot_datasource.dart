import 'package:http/http.dart' as http;

import '../../../core/constants/app_endpoints.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/panel_fault.dart';
import '../../../domain/entities/panel_reading.dart';
import 'iot_device_datasource.dart';

/// Transport for REAL hardware.
///
/// A production deployment would replace [SimulatedIotDatasource] with this
/// class once the ESP32/ESP8266 hub (per-plate INA219/INA226 sensors +
/// DS18B20 temperature probes + relay for disconnection) is reachable.
///
/// Expected hub contract (see docs/iot_integration.md):
///   GET  {base}/api/v1/panels                -> JSON list of readings
///   POST {base}/api/v1/panels/command        -> {"deviceId":"...","on":true}
///   POST {base}/api/v1/diagnostics           -> run self-test
///
/// This file is intentionally a documented, compiling skeleton so the
/// project demonstrates how the same app code swaps simulator <-> hardware.
class MqttIotDatasource implements IotDeviceDatasource {
  MqttIotDatasource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  bool _connected = false;
  final Map<String, PanelFaultType> _lastKnownFaults = {};

  @override
  bool get isConnected => _connected;

  @override
  Future<void> connect() async {
    try {
      final Uri uri =
          Uri.parse('${AppEndpoints.iotHubBaseUrl}/health');
      final http.Response res =
          await _client.get(uri).timeout(AppEndpoints.networkTimeout);
      _connected = res.statusCode == 200;
    } catch (e) {
      _connected = false;
      AppLogger.e('MqttDS', 'Hub unreachable', e);
    }
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }

  @override
  Future<PanelReading?> readPanel(IotReadingRequest request) async {
    if (!_connected) return null;
    try {
      final Uri uri = Uri.parse(
          '${AppEndpoints.iotHubBaseUrl}${AppEndpoints.iotHubReadingsPath}/${request.deviceId}');
      final http.Response res =
          await _client.get(uri).timeout(AppEndpoints.networkTimeout);
      if (res.statusCode != 200) return null;
      // Expected payload:
      // {"voltage":40.2,"current":9.8,"power":394.0,"temperature":48.5,
      //  "irradiance":910.0,"efficiency":93.2,"fault":"none"}
      // Parse with the same JSON contract as the simulator output.
      // (Kept as a TODO to avoid a hard dependency on device firmware here.)
      // TODO(Team7H): map the hub JSON into PanelReading.
      return PanelReading.zero();
    } catch (e) {
      AppLogger.e('MqttDS', 'readPanel failed for ${request.deviceId}', e);
      return null;
    }
  }

  @override
  Future<void> sendPowerCommand(String deviceId, bool on) async {
    try {
      final Uri uri = Uri.parse(
          '${AppEndpoints.iotHubBaseUrl}${AppEndpoints.iotHubCommandPath}');
      await _client
          .post(uri, body: {'deviceId': deviceId, 'on': on ? '1' : '0'})
          .timeout(AppEndpoints.networkTimeout);
    } catch (e) {
      AppLogger.e('MqttDS', 'sendPowerCommand failed', e);
    }
  }

  @override
  PanelFaultType activeFaultOf(String deviceId) =>
      _lastKnownFaults[deviceId] ?? PanelFaultType.none;

  @override
  void injectFault(String deviceId, PanelFaultType fault) {
    // Real hardware cannot be "injected" — faults arrive from the hub.
  }

  @override
  void clearFault(String deviceId) {
    _lastKnownFaults.remove(deviceId);
  }

  @override
  void clearAllFaults() {
    _lastKnownFaults.clear();
  }
}
