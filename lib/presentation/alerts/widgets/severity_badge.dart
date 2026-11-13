import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/alert.dart';

/// Severity -> color mapping in one place.
Color severityColor(AlertSeverity s) {
  switch (s) {
    case AlertSeverity.info:
      return AppColors.info;
    case AlertSeverity.low:
      return const Color(0xFF38BDF8);
    case AlertSeverity.medium:
      return AppColors.warning;
    case AlertSeverity.high:
      return const Color(0xFFF97316);
    case AlertSeverity.critical:
      return AppColors.danger;
  }
}

/// Icon for an alert type.
IconData alertTypeIcon(AlertType type) {
  switch (type) {
    case AlertType.fault:
      return Icons.report_problem;
    case AlertType.performance:
      return Icons.trending_down;
    case AlertType.temperature:
      return Icons.device_thermostat;
    case AlertType.connection:
      return Icons.wifi_off;
    case AlertType.maintenanceReminder:
      return Icons.engineering;
    case AlertType.system:
      return Icons.notifications_active;
  }
}

/// Colored severity pill.
class SeverityBadge extends StatelessWidget {
  const SeverityBadge({super.key, required this.severity, this.compact = false});

  final AlertSeverity severity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Color color = severityColor(severity);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 2.5 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity.label,
        style: TextStyle(
          fontSize: compact ? 9.5 : 10.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
