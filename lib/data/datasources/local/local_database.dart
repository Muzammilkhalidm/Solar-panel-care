import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper over SharedPreferences holding every JSON blob.
class LocalDatabase {
  LocalDatabase(this._prefs);

  final SharedPreferences _prefs;

  static const String kPanels = 'panels_v1';
  static const String kAlerts = 'alerts_v1';
  static const String kUsers = 'users_v1';
  static const String kSession = 'session_v1';
  static const String kSettings = 'settings_v1';
  static const String kWeekly = 'weekly_energy_v1';
  static const String kOnboarding = 'onboarding_v1';

  String? read(String key) => _prefs.getString(key);

  Future<void> write(String key, String value) => _prefs.setString(key, value);

  bool readBool(String key) => _prefs.getBool(key) ?? false;

  Future<void> writeBool(String key, bool value) =>
      _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  /// Nuclear option — wipes monitoring data but keeps the onboarding flag.
  Future<void> clearMonitoringData() async {
    await _prefs.remove(kPanels);
    await _prefs.remove(kAlerts);
    await _prefs.remove(kWeekly);
  }
}
