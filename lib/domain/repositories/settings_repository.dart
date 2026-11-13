import '../entities/system_settings.dart';

/// Contract for system settings persistence.
abstract class SettingsRepository {
  Future<SystemSettings> getSettings();

  Future<void> saveSettings(SystemSettings settings);
}
