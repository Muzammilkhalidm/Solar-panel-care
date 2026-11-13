/// Global application constants for Solar Panel Care.
/// Developed by Panel Care Team 7-H.
class AppConstants {
  AppConstants._();

  static const String appName = 'Solar Panel Care';
  static const String appTagline = 'Advanced IoT Solar Monitoring';
  static const String developerCredit = 'Developed by Panel Care Team 7-H';
  static const String developerName = 'Panel Care Team 7-H';
  static const String developerRole = 'Solar IoT & Flutter Team';
  static const String appVersion = '2.0.0';
  static const String buildNumber = '2';

  /// Demo login credentials (seeded automatically on first run).
  static const String demoEmail = 'demo@solarcare.pk';
  static const String demoPassword = 'solar123';
  static const String demoUserName = 'Panel Care Owner';

  /// How often the simulated IoT device pushes a new reading per panel.
  static const Duration iotTickInterval = Duration(seconds: 4);

  /// Maximum number of live readings kept in memory per panel chart.
  static const int maxHistoryPoints = 48;

  /// Maximum number of system-wide snapshots kept for dashboard chart.
  static const int maxSystemSnapshots = 40;

  /// Default alert thresholds.
  static const double defaultTempThreshold = 75.0;
  static const double defaultPerformanceThreshold = 55.0;

  /// Energy economics used for the savings screen.
  static const double pkrPerKwh = 58.0;
  static const double co2KgPerKwh = 0.55;
  static const double kgCo2PerTreeYear = 21.0;

  /// A single damaged plate can drag the whole string down — the app warns
  /// the user with this standard line on critical alerts.
  static const String cascadeWarning =
      'One damaged plate can reduce the output of the whole solar array. '
      'Repair or replace it as soon as possible.';
}
