import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_endpoints.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/weather_info.dart';
import '../../models/weather_model.dart';

/// Live weather from Open-Meteo with a graceful simulated fallback so the
/// dashboard never breaks offline.
class WeatherApiDatasource {
  WeatherApiDatasource({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<WeatherInfo> getWeather() async {
    try {
      final Uri uri = Uri.parse(
          '${AppEndpoints.openMeteoBase}${AppEndpoints.openMeteoQuery}');
      final http.Response res =
          await _client.get(uri).timeout(AppEndpoints.networkTimeout);
      if (res.statusCode == 200) {
        final Map<String, dynamic> json =
            jsonDecode(res.body) as Map<String, dynamic>;
        return WeatherModel.fromOpenMeteo(json);
      }
      AppLogger.i('Weather', 'Non-200 from Open-Meteo: ${res.statusCode}');
    } catch (e) {
      AppLogger.i('Weather', 'Open-Meteo unreachable, using simulation');
    }
    return WeatherModel.simulated();
  }
}
