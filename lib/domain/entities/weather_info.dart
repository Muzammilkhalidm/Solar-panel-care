/// Weather snapshot used by the dashboard banner.
class WeatherInfo {
  WeatherInfo({
    required this.condition,
    required this.temperatureC,
    required this.cloudCover,
    required this.humidity,
    required this.isSunny,
    required this.fetchedAt,
    required this.source,
  });

  final String condition;
  final double temperatureC;
  final int cloudCover;
  final int humidity;
  final bool isSunny;
  final DateTime fetchedAt;
  final String source;

  String get icon {
    if (isSunny) return '☀';
    if (cloudCover > 75) return '☁';
    return '⛅';
  }
}
