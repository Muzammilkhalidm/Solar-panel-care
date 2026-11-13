import 'package:flutter/material.dart';

/// Brand + status colors shared by both themes.
///
/// Premium "Voltix" solar identity:
/// warm cream surfaces, charcoal hero cards and a glowing amber-orange
/// energy gradient.
/// Developed by Panel Care Team 7-H.
class AppColors {
  AppColors._();

  // ---- Brand: glowing sun ----
  static const Color sunAmber = Color(0xFFF7A021);
  static const Color sunOrange = Color(0xFFFF7E2D);
  static const Color deepOrange = Color(0xFFE85D04);
  static const Color sunGlow = Color(0xFFFFC65C);
  static const Color honey = Color(0xFFF5D06F);

  // ---- Premium neutrals ----
  static const Color cream = Color(0xFFEAE5DA);
  static const Color creamDeep = Color(0xFFDFD8C8);
  static const Color charcoal = Color(0xFF1D1B17);
  static const Color charcoalSoft = Color(0xFF2A2721);
  static const Color midnight = Color(0xFF12110E);
  static const Color skyBlue = Color(0xFF2E7DD1);

  // ---- Semantic status ----
  static const Color success = Color(0xFF3D9A50);
  static const Color warning = Color(0xFFF5A524);
  static const Color danger = Color(0xFFE5484D);
  static const Color info = Color(0xFF3B82F6);
  static const Color neutralGrey = Color(0xFF8A94A6);

  // ---- Energy gradient (used on buttons, gauges, bars) ----
  static const LinearGradient energyGradient = LinearGradient(
    colors: [sunGlow, sunAmber, sunOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ---- Severity scale ----
  static Color severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return danger;
      case 'high':
        return deepOrange;
      case 'medium':
        return warning;
      case 'low':
        return const Color(0xFF38BDF8);
      default:
        return info;
    }
  }

  // ---- Panel status ----
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return success;
      case 'fault':
        return danger;
      case 'maintenance':
        return warning;
      case 'offline':
        return neutralGrey;
      case 'off':
        return const Color(0xFF64748B);
      default:
        return info;
    }
  }

  static IconData statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return Icons.check_circle;
      case 'fault':
        return Icons.report_problem;
      case 'maintenance':
        return Icons.engineering;
      case 'offline':
        return Icons.wifi_off;
      case 'off':
        return Icons.power_off;
      default:
        return Icons.help_outline;
    }
  }
}
