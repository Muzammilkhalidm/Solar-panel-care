import '../../core/utils/date_time_utils.dart';
import '../../domain/entities/weather_info.dart';

/// Builds [WeatherInfo] from the Open-Meteo payload or simulates one.
class WeatherModel extends WeatherInfo {
  WeatherModel({
    required super.condition,
    required super.temperatureC,
    required super.cloudCover,
    required super.humidity,
    required super.isSunny,
    required super.fetchedAt,
    required super.source,
  });

  /// Parses the Open-Meteo `current` block.
  factory WeatherModel.fromOpenMeteo(Map<String, dynamic> json) {
    final current =
        Map<String, dynamic>.from(json['current'] as Map? ?? const {});
    final double temp = (current['temperature_2m'] as num? ?? 30).toDouble();
    final int cloud = (current['cloud_cover'] as num? ?? 40).toInt();
    final int humidity = (current['relative_humidity_2m'] as num? ?? 40).toInt();

    String condition;
    if (cloud < 25) {
      condition = 'Clear Sky';
    } else if (cloud < 60) {
      condition = 'Partly Cloudy';
    } else {
      condition = 'Cloudy';
    }

    return WeatherModel(
      condition: condition,
      temperatureC: temp,
      cloudCover: cloud,
      humidity: humidity,
      isSunny: cloud < 45,
      fetchedAt: DateTime.now(),
      source: 'Open-Meteo (live)',
    );
  }

  /// Offline-friendly simulated weather driven by the solar curve.
  factory WeatherModel.simulated() {
    final bool day = AppDateTimeUtils.isDaytime();
    final double factor = AppDateTimeUtils.solarFactor();
    final int cloud = day ? 22 : 60;
    final double temp = day ? 24 + factor * 16 : 19.0;

    return WeatherModel(
      condition: day
          ? (cloud < 30 ? 'Sunny (simulated)' : 'Partly Cloudy (simulated)')
          : 'Night (simulated)',
      temperatureC: temp,
      cloudCover: cloud,
      humidity: 42,
      isSunny: day && cloud < 45,
      fetchedAt: DateTime.now(),
      source: 'Simulated',
    );
  }
}
