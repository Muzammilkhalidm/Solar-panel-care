import '../../domain/entities/system_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/local_database.dart';
import '../models/settings_model.dart';
import 'dart:convert';

/// Loads/saves system settings as JSON.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._db);

  final LocalDatabase _db;
  SystemSettings? _cache;

  @override
  Future<SystemSettings> getSettings() async {
    if (_cache != null) return _cache!;
    try {
      final String? raw = _db.read(LocalDatabase.kSettings);
      if (raw != null && raw.isNotEmpty) {
        final Map<String, dynamic> json =
            jsonDecode(raw) as Map<String, dynamic>;
        _cache = SettingsModel.fromJson(json);
        return _cache!;
      }
    } catch (_) {
      // fall through to defaults
    }
    _cache = SystemSettings();
    return _cache!;
  }

  @override
  Future<void> saveSettings(SystemSettings settings) async {
    _cache = settings;
    final String raw =
        jsonEncode(SettingsModel.fromEntity(settings).toJson());
    await _db.write(LocalDatabase.kSettings, raw);
  }

  /// Restores defaults (used by "Reset demo data").
  Future<void> reset() async {
    _cache = SystemSettings();
    await saveSettings(_cache!);
  }
}
