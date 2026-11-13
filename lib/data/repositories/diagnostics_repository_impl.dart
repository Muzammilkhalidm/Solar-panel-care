import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../../domain/entities/panel.dart';
import '../../domain/entities/panel_fault.dart';
import '../../domain/entities/panel_reading.dart';
import '../../domain/repositories/diagnostics_repository.dart';
import '../datasources/remote/iot_device_datasource.dart';

/// Simulated deep-diagnostics run: walks through 7 electrical checks with
/// realistic pauses and produces a report with a recommendation.
class DiagnosticsRepositoryImpl implements DiagnosticsRepository {
  DiagnosticsRepositoryImpl(this._iot);

  final IotDeviceDatasource _iot;
  final Random _random = Random();

  @override
  Future<DiagnosticReport> runDiagnostics(Panel panel) async {
    final DateTime startedAt = DateTime.now();
    final List<DiagnosticCheck> checks = [];

    Future<void> pause() =>
        Future<void>.delayed(const Duration(milliseconds: 420));

    // 1 — IoT link
    await pause();
    checks.add(DiagnosticCheck(
      name: 'IoT Device Link',
      passed: _iot.isConnected && panel.status != PanelStatus.offline,
      detail: _iot.isConnected
          ? 'Device ${panel.deviceId} responded to ping.'
          : 'Device ${panel.deviceId} did not respond.',
      value: _iot.isConnected ? 'OK' : 'NO LINK',
    ));

    // 2 — fresh reading
    final PanelReading? reading = await _iot.readPanel(IotReadingRequest(
      deviceId: panel.deviceId,
      ratedWatts: panel.ratedWatts,
      forceSunlight: true,
    ));
    await pause();

    checks.add(DiagnosticCheck(
      name: 'Voltage Level',
      passed: reading != null && reading.voltage >= 30 && reading.voltage <= 50,
      detail: reading == null
          ? 'No voltage reading received.'
          : 'String voltage within MPPT range.',
      value: reading == null ? '—' : '${reading.voltage.toStringAsFixed(1)} V',
    ));

    checks.add(DiagnosticCheck(
      name: 'Current Output',
      passed: reading != null && reading.current >= 0,
      detail: reading == null
          ? 'No current reading received.'
          : (reading.power > 5
              ? 'Plate is delivering current to the string.'
              : 'Plate is producing no current right now.'),
      value: reading == null ? '—' : '${reading.current.toStringAsFixed(2)} A',
    ));

    // 3 — temperature
    final double temp = reading?.temperature ?? panel.temperature;
    checks.add(DiagnosticCheck(
      name: 'Cell Temperature',
      passed: temp < AppConstants.defaultTempThreshold,
      detail: temp < AppConstants.defaultTempThreshold
          ? 'Temperature inside safe operating range.'
          : 'Temperature above safe range — hotspot risk.',
      value: '${temp.toStringAsFixed(1)}°C',
    ));

    // 4 — output vs expectation
    final double sun =
        AppDateTimeUtils.solarFactor(forceSunlight: true);
    final double expected = panel.ratedWatts * (sun <= 0.02 ? 0.5 : sun) * 0.9;
    final double actual = reading?.power ?? panel.power;
    final double ratio = expected > 5 ? actual / expected : 1;
    checks.add(DiagnosticCheck(
      name: 'Output vs Expected',
      passed: ratio > 0.6,
      detail: ratio > 0.6
          ? 'Production matches the current sunlight level.'
          : 'Plate is under-producing for this sunlight level.',
      value: '${(ratio * 100).toStringAsFixed(0)}%',
    ));

    // 5 — surface / soiling estimate
    final double eff = reading?.efficiency ?? panel.efficiency;
    checks.add(DiagnosticCheck(
      name: 'Surface Efficiency',
      passed: eff > 65,
      detail: eff > 65
          ? 'No heavy soiling detected on the surface.'
          : 'Heavy soiling or damage suspected on the surface.',
      value: '${eff.toStringAsFixed(1)}%',
    ));

    // 6 — fault registry
    final PanelFaultType fault = _iot.activeFaultOf(panel.deviceId);
    checks.add(DiagnosticCheck(
      name: 'Fault Registry',
      passed: !fault.isActive,
      detail: fault.isActive
          ? 'Active fault found in device registry.'
          : 'No electrical fault registered.',
      value: fault.label,
    ));

    // 7 — internal insulation roll (simulated)
    final int leakage = _random.nextInt(100);
    checks.add(DiagnosticCheck(
      name: 'Insulation / Leakage',
      passed: leakage > 12,
      detail: leakage > 12
          ? 'Insulation resistance healthy.'
          : 'Insulation below recommended resistance.',
      value: '${1000 + leakage * 7} MΩ',
    ));

    final DateTime completedAt = DateTime.now();
    final int passedCount = checks.where((c) => c.passed).length;
    final int health = ((passedCount / checks.length) * 100).round();

    String recommendation;
    if (health == 100) {
      recommendation =
          'All checks passed. ${panel.name} is healthy — no action needed.';
    } else if (!fault.isActive && health >= 80) {
      recommendation =
          'Minor observations only. Re-run diagnostics after the next cleaning '
          'cycle and keep monitoring from the app.';
    } else {
      recommendation =
          '${panel.name} needs attention. ${AppConstants.cascadeWarning} '
          'Recommended action: ${fault.isActive ? fault.recommendation : "request a technician visit from the alert screen."}';
    }

    AppLogger.i('Diagnostics',
        '${panel.id}: $passedCount/${checks.length} checks passed');

    return DiagnosticReport(
      id: 'DIA-${completedAt.millisecondsSinceEpoch}',
      panelId: panel.id,
      panelName: panel.name,
      startedAt: startedAt,
      completedAt: completedAt,
      checks: checks,
      overallHealth: health,
      recommendation: recommendation,
    );
  }
}
