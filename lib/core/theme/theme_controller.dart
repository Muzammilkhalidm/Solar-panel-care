import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and exposes the selected ThemeMode (system / light / dark).
/// The user asked for both dark and light support — this is the controller.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs);

  static const String _key = 'theme_mode_v1';

  final SharedPreferences _prefs;
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    final String? stored = _prefs.getString(_key);
    if (stored == ThemeMode.light.name) {
      _mode = ThemeMode.light;
    } else if (stored == ThemeMode.dark.name) {
      _mode = ThemeMode.dark;
    } else {
      _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  bool get isDarkNow {
    final Brightness b = _platformBrightness();
    if (_mode == ThemeMode.dark) return true;
    if (_mode == ThemeMode.light) return false;
    return b == Brightness.dark;
  }

  Brightness _platformBrightness() {
    // Read from the platform dispatcher (works before MaterialApp builds).
    return WidgetsBinding
            .instance.platformDispatcher.platformBrightness ??
        Brightness.light;
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    await _prefs.setString(_key, mode.name);
  }

  /// Quick toggle used from the dashboard AppBar.
  Future<void> toggleLightDark() async {
    if (isDarkNow) {
      await setMode(ThemeMode.light);
    } else {
      await setMode(ThemeMode.dark);
    }
  }
}
