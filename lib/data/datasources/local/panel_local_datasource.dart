import 'dart:convert';

import '../../../core/utils/logger.dart';
import '../../models/panel_model.dart';
import 'local_database.dart';
import '../../../domain/entities/panel.dart';

/// Loads/saves the full panel list as JSON in SharedPreferences.
class PanelLocalDatasource {
  PanelLocalDatasource(this._db);

  final LocalDatabase _db;

  /// Returns null when nothing has been stored yet (first launch).
  Future<List<Panel>?> loadPanels() async {
    try {
      final String? raw = _db.read(LocalDatabase.kPanels);
      if (raw == null || raw.isEmpty) return null;
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return PanelModel.listToEntity(list);
    } catch (e) {
      AppLogger.e('PanelLocalDS', 'Failed to load panels', e);
      return null;
    }
  }

  Future<void> savePanels(List<Panel> panels) async {
    try {
      final String raw = jsonEncode(PanelModel.listFromEntity(panels));
      await _db.write(LocalDatabase.kPanels, raw);
    } catch (e) {
      AppLogger.e('PanelLocalDS', 'Failed to save panels', e);
    }
  }
}
