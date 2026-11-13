import 'package:flutter/material.dart';

import '../constants/app_globals.dart';

/// Global snackbars usable from services (they hold the navigator key).
class AppSnackBar {
  AppSnackBar._();

  static const Color cSuccess = Color(0xFF2E9E5B);
  static const Color cError = Color(0xFFE5484D);
  static const Color cInfo = Color(0xFF3B82F6);
  static const Color cWarning = Color(0xFFF5A524);

  static void show(String message, {Color color = cInfo, String title = ''}) {
    final ctx = appNavigatorKey.currentContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            title.isEmpty ? message : '$title — $message',
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
            },
          ),
        ),
      );
  }

  static void success(String message) => show(message, color: cSuccess);
  static void error(String message) => show(message, color: cError);
  static void info(String message) => show(message, color: cInfo);
  static void warning(String message) => show(message, color: cWarning);
}
