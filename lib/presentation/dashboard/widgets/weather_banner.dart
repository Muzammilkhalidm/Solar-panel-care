import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../domain/entities/weather_info.dart';

/// Premium weather strip — soft cream card with a sun accent.
class WeatherBanner extends StatelessWidget {
  const WeatherBanner({
    super.key,
    required this.weather,
    required this.loading,
  });

  final WeatherInfo? weather;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final bool goodSolar = weather?.isSunny ?? false;

    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: goodSolar
              ? [
                  const Color(0xFFFF7E2D).withOpacity(0.16),
                  const Color(0xFFFFC65C).withOpacity(0.10),
                ]
              : [
                  p.surfaceAlt,
                  p.surfaceAlt.withOpacity(0.6),
                ],
        ),
        border: Border.all(
          color: goodSolar
              ? const Color(0xFFFF7E2D).withOpacity(0.25)
              : p.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: goodSolar
                  ? const Color(0xFFFF7E2D).withOpacity(0.18)
                  : p.surfaceAlt,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              loading ? '…' : (weather?.icon ?? '☀'),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loading
                      ? 'Fetching weather…'
                      : (weather?.condition ?? 'Weather unavailable'),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  weather == null
                      ? 'Production estimate may vary'
                      : '${weather!.temperatureC.toStringAsFixed(0)}°C • '
                          'Cloud ${weather!.cloudCover}% • '
                          '${weather!.isSunny ? "Great solar day" : "Reduced output expected"}',
                  style: TextStyle(fontSize: 11.5, color: p.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: p.surfaceAlt.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weather?.source ?? '',
              style: TextStyle(fontSize: 9.5, color: p.textFaint),
            ),
          ),
        ],
      ),
    );
  }
}
