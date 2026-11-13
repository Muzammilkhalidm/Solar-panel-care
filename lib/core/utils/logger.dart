import 'package:flutter/foundation.dart';

/// Tiny tagged logger that stays silent in release builds.
class AppLogger {
  AppLogger._();

  static void d(String tag, String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[SOLARCARE][$tag][DEBUG] $message');
    }
  }

  static void i(String tag, String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[SOLARCARE][$tag][INFO] $message');
    }
  }

  static void e(String tag, String message, [Object? error]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[SOLARCARE][$tag][ERROR] $message ${error ?? ''}');
    }
  }
}
