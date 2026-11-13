import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/constants/app_globals.dart';

/// Lightweight global notification channel (in-app snackbar banner) plus a
/// history log. Swappable with FCM later without touching callers.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static final GlobalKey<NavigatorState> navigatorKey = appNavigatorKey;

  bool enabled = true;

  final List<AppNotificationLog> history = <AppNotificationLog>[];

  void show({
    required String title,
    required String body,
    required int colorValue,
  }) {
    final Color color = Color(colorValue);
    history.insert(
      0,
      AppNotificationLog(
        title: title,
        body: body,
        color: color,
        time: DateTime.now(),
      ),
    );
    if (history.length > 50) history.removeLast();

    if (!enabled) return;

    final BuildContext? ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          duration: const Duration(seconds: 4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: const TextStyle(fontSize: 12.5, color: Colors.white),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () =>
                ScaffoldMessenger.of(ctx).hideCurrentSnackBar(),
          ),
        ),
      );
  }

  /// Debug dump helper (used in tests / logs).
  String dump() {
    final List<Map<String, String>> rows = history
        .map((n) => {'title': n.title, 'body': n.body})
        .toList();
    return jsonEncode(rows);
  }
}
