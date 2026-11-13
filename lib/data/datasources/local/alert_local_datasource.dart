import 'dart:convert';

import '../../../core/utils/logger.dart';
import '../../models/alert_model.dart';
import 'local_database.dart';
import '../../../domain/entities/alert.dart';

/// Loads/saves alerts as JSON.
class AlertLocalDatasource {
  AlertLocalDatasource(this._db);

  final LocalDatabase _db;

  Future<List<Alert>?> loadAlerts() async {
    try {
      final String? raw = _db.read(LocalDatabase.kAlerts);
      if (raw == null || raw.isEmpty) return null;
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return AlertModel.listToEntity(list);
    } catch (e) {
      AppLogger.e('AlertLocalDS', 'Failed to load alerts', e);
      return null;
    }
  }

  Future<void> saveAlerts(List<Alert> alerts) async {
    try {
      // Keep storage bounded: latest 120 alerts.
      final List<Alert> trimmed = alerts.length > 120
          ? alerts.sublist(alerts.length - 120)
          : alerts;
      final String raw = jsonEncode(AlertModel.listFromEntity(trimmed));
      await _db.write(LocalDatabase.kAlerts, raw);
    } catch (e) {
      AppLogger.e('AlertLocalDS', 'Failed to save alerts', e);
    }
  }
}
