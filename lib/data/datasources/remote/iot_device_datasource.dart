import '../../../domain/entities/panel_fault.dart';
import '../../../domain/entities/panel_reading.dart';

/// Request for one reading cycle of a plate's IoT device.
class IotReadingRequest {
  IotReadingRequest({
    required this.deviceId,
    required this.ratedWatts,
    this.forceSunlight = false,
  });

  final String deviceId;
  final double ratedWatts;
  final bool forceSunlight;
}

/// Contract every IoT transport implements (simulated now, MQTT for real
/// hardware — see docs/iot_integration.md).
abstract class IotDeviceDatasource {
  Future<void> connect();
  Future<void> disconnect();
  bool get isConnected;

  /// Returns null when the device does not respond (connection lost).
  Future<PanelReading?> readPanel(IotReadingRequest request);

  Future<void> sendPowerCommand(String deviceId, bool on);

  PanelFaultType activeFaultOf(String deviceId);
  void injectFault(String deviceId, PanelFaultType fault);
  void clearFault(String deviceId);
  void clearAllFaults();
}
