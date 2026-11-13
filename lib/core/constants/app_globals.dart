import 'package:flutter/material.dart';

import '../theme/ui_helpers.dart';

/// Global navigator key so services can show UI (alarm banners, snackbars)
/// from anywhere without a BuildContext.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Simple in-memory app-wide notifications log entry.
class AppNotificationLog {
  AppNotificationLog({
    required this.title,
    required this.body,
    required this.color,
    required this.time,
  });

  final String title;
  final String body;
  final Color color;
  final DateTime time;
}
