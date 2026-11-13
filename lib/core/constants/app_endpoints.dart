/// Remote endpoints. The app ships with an offline-first IoT simulator,
/// but the same datasources can point to a real hub through these endpoints.
class AppEndpoints {
  AppEndpoints._();

  /// Open-Meteo public weather API (no key required).
  static const String openMeteoBase = 'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoQuery =
      '?latitude=31.5204&longitude=74.3587'
      '&current=temperature_2m,relative_humidity_2m,cloud_cover';

  /// MQTT / REST bridge of a real IoT solar monitoring hub.
  /// Replace with your device endpoint when going to production.
  static const String iotHubBaseUrl = 'http://192.168.1.100:8080';
  static const String iotHubReadingsPath = '/api/v1/panels';
  static const String iotHubCommandPath = '/api/v1/panels/command';
  static const String iotHubDiagnosticsPath = '/api/v1/diagnostics';

  static const Duration networkTimeout = Duration(seconds: 5);
}
