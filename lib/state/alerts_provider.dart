import 'package:flutter/foundation.dart';

import '../data/repositories/alert_repository_impl.dart';
import '../domain/entities/alert.dart';
import '../domain/entities/maintenance_record.dart';
import '../domain/usecases/get_alerts.dart';
import '../domain/usecases/request_repair.dart';
import '../domain/usecases/resolve_alert.dart';
import '../services/alarm_player_service.dart';
import '../services/haptic_service.dart';

/// Alert list state + emergency alarm control.
class AlertsProvider extends ChangeNotifier {
  AlertsProvider({
    required GetAlerts getAlerts,
    required ResolveAlert resolveAlert,
    required RequestRepair requestRepair,
    required AlertRepositoryImpl repository,
    required AlarmPlayerService alarmPlayer,
    required HapticService haptics,
  })  : _getAlerts = getAlerts,
        _resolveAlert = resolveAlert,
        _requestRepair = requestRepair,
        _repository = repository,
        _alarmPlayer = alarmPlayer,
        _haptics = haptics;

  final GetAlerts _getAlerts;
  final ResolveAlert _resolveAlert;
  final RequestRepair _requestRepair;
  final AlertRepositoryImpl _repository;
  final AlarmPlayerService _alarmPlayer;
  final HapticService _haptics;

  List<Alert> _alerts = [];
  bool loading = false;

  List<Alert> get alerts => List.unmodifiable(_alerts);

  List<Alert> get activeAlerts =>
      _alerts.where((a) => a.isActive).toList();

  List<Alert> get resolvedAlerts =>
      _alerts.where((a) => a.resolved).toList();

  int get activeCount => activeAlerts.length;

  int get criticalCount => activeAlerts
      .where((a) =>
          a.severity == AlertSeverity.critical ||
          a.severity == AlertSeverity.high)
      .length;

  bool get alarmRinging => _alarmPlayer.isPlaying;

  Alert? get loudestActiveAlert {
    for (final Alert a in activeAlerts) {
      if (a.severity == AlertSeverity.critical) return a;
    }
    for (final Alert a in activeAlerts) {
      if (a.severity == AlertSeverity.high) return a;
    }
    return activeAlerts.isNotEmpty ? activeAlerts.first : null;
  }

  Future<void> refresh() async {
    _alerts = await _getAlerts.execute();
    notifyListeners();
  }

  Future<void> resolve(String alertId) async {
    await _resolveAlert.execute(alertId);
    await refresh();
  }

  Future<void> resolveAll() async {
    await _repository.resolveAll();
    await refresh();
  }

  Future<void> clearResolved() async {
    await _repository.clearResolved();
    await refresh();
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
    await refresh();
  }

  Future<MaintenanceRecord?> requestTechnician(Alert alert, {String? note}) async {
    final MaintenanceRecord? record =
        await _requestRepair.execute(alert: alert, note: note);
    await refresh();
    return record;
  }

  Future<void> stopAlarm() async {
    await _alarmPlayer.stopAlarm();
    await _haptics.lightTick();
    notifyListeners();
  }
}
