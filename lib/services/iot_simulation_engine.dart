import 'dart:async';

import '../core/constants/app_constants.dart';
import '../data/datasources/remote/iot_device_datasource.dart';
import '../domain/entities/panel.dart';
import '../domain/entities/panel_fault.dart';
import '../domain/entities/panel_reading.dart';
import '../domain/entities/system_settings.dart';
import '../domain/repositories/panel_repository.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/repositories/stats_repository.dart';
import 'alert_engine.dart';
import 'notification_service.dart';
import '../core/utils/logger.dart';

/// The heartbeat of the system.
///
/// Every [AppConstants.iotTickInterval] the engine:
///  1. reads each plate's IoT device (or marks it offline),
///  2. mutates the live readings + accumulates energy,
///  3. feeds the [AlertEngine] (which can ring the alarm),
///  4. auto-shuts-down critically faulty plates (if enabled),
///  5. records a system-wide snapshot for the dashboard chart,
///  6. periodically persists everything.
class IotSimulationEngine {
  IotSimulationEngine({
    required this.panelRepository,
    required this.statsRepository,
    required this.settingsRepository,
    required this.alertEngine,
    required this.iot,
  });

  final PanelRepository panelRepository;
  final StatsRepository statsRepository;
  final SettingsRepository settingsRepository;
  final AlertEngine alertEngine;
  final IotDeviceDatasource iot;

  Timer? _timer;
  bool _running = false;
  int _tickCount = 0;

  final StreamController<int> _tickController =
      StreamController<int>.broadcast();

  /// Fires after every completed tick (used by providers to refresh UI).
  Stream<int> get tickStream => _tickController.stream;

  bool get isRunning => _running;
  int get tickCount => _tickCount;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    AppLogger.i('Engine', 'IoT heartbeat started');
    await tick();
    _timer = Timer.periodic(AppConstants.iotTickInterval, (_) => tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    AppLogger.i('Engine', 'IoT heartbeat stopped');
  }

  /// One immediate cycle (used after manual commands / fault injection).
  Future<void> tickNow() => tick();

  Future<void> tick() async {
    try {
      final SystemSettings settings = await settingsRepository.getSettings();
      final List<Panel> panels = await panelRepository.getPanels();

      double totalPower = 0;
      double effSum = 0;
      int producing = 0;

      for (final Panel panel in panels) {
        if (!panel.powerEnabled) {
          _applyPoweredOff(panel);
          continue;
        }
        if (panel.status == PanelStatus.maintenance) continue;

        final PanelReading? reading = await iot.readPanel(IotReadingRequest(
          deviceId: panel.deviceId,
          ratedWatts: panel.ratedWatts,
          forceSunlight: settings.forceSunlight,
        ));

        if (reading == null) {
          panel.status = PanelStatus.offline;
          panel.power = 0;
          panel.current = 0;
          panel.voltage = 0;
          panel.irradiance = 0;
          panel.efficiency = 0;
        } else {
          panel.voltage = reading.voltage;
          panel.current = reading.current;
          panel.power = reading.power;
          panel.temperature = reading.temperature;
          panel.irradiance = reading.irradiance;
          panel.efficiency = reading.efficiency;
          panel.activeFault = iot.activeFaultOf(panel.deviceId);
          panel.status = panel.activeFault.isActive
              ? PanelStatus.fault
              : PanelStatus.online;

          // Energy accumulation: W * seconds / 3.6e6 = kWh
          final double kwh = panel.power *
              AppConstants.iotTickInterval.inSeconds /
              3600000.0;
          panel.energyTodayKwh += kwh;
          panel.lifetimeEnergyKwh += kwh;

          _appendHistory(panel, reading);
        }

        _updateHealth(panel);

        // Threshold + fault evaluation -> may trigger alarm.
        await alertEngine.evaluatePanel(panel, settings);

        // Safety automation: cut a critically damaged plate.
        if (settings.autoShutdownOnFault &&
            panel.activeFault.isCritical &&
            panel.powerEnabled) {
          await panelRepository.setPowerEnabled(panel.id, false);
          NotificationService.instance.show(
            title: 'Auto Shutdown',
            body:
                '${panel.name} was powered OFF automatically — ${panel.activeFault.label}.',
            colorValue: 0xFFE5484D,
          );
        }

        totalPower += panel.power;
        if (panel.power > 5) {
          effSum += panel.efficiency;
          producing++;
        }
      }

      final double avgEff = producing > 0 ? effSum / producing : 0;
      statsRepository.recordSystemSnapshot(totalPower, avgEff);

      _tickCount++;
      if (_tickCount % 10 == 0) {
        await panelRepository.persist();
      }
      _tickController.add(_tickCount);
    } catch (e) {
      AppLogger.e('Engine', 'Tick failed', e);
    }
  }

  void _applyPoweredOff(Panel panel) {
    panel.power = 0;
    panel.current = 0;
    panel.voltage = 0;
    panel.irradiance = 0;
    panel.efficiency = 0;
    panel.status = PanelStatus.off;
  }

  void _appendHistory(Panel panel, PanelReading reading) {
    panel.history.add(reading);
    while (panel.history.length > AppConstants.maxHistoryPoints) {
      panel.history.removeAt(0);
    }
  }

  void _updateHealth(Panel panel) {
    if (panel.activeFault.isActive) {
      final int penalty = panel.activeFault.healthPenalty;
      panel.healthScore = (panel.healthScore - penalty).clamp(0, 100).toInt();
    } else if (panel.healthScore < 100) {
      panel.healthScore = (panel.healthScore + 1).clamp(0, 100).toInt();
    }
  }

  /// Removes the engine safely (called from the shell dispose).
  void dispose() {
    stop();
    _tickController.close();
  }
}
