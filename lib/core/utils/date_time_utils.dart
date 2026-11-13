import 'dart:math';

/// Date/time helpers plus the shared solar production curve used by the
/// IoT simulation and the analytics screens.
class AppDateTimeUtils {
  AppDateTimeUtils._();

  static String greeting() {
    final int hour = DateTime.now().hour;
    if (hour < 5) return 'Good Night';
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  static bool isDaytime() {
    final int hour = DateTime.now().hour;
    return hour >= 6 && hour < 19;
  }

  static String dayLabel(int weekday) {
    const List<String> names = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    return names[(weekday - 1).clamp(0, 6)];
  }

  /// Solar irradiance factor 0..1 for the current moment.
  /// 0 at night, peak at solar noon. [forceSunlight] pins the factor to a
  /// bright value so demos work at any hour (Demo Sun toggle in settings).
  static double solarFactor({bool forceSunlight = false}) {
    if (forceSunlight) return 0.88;
    final DateTime now = DateTime.now();
    final double hour = now.hour + now.minute / 60.0;
    if (hour <= 6 || hour >= 19) return 0.0;
    return max(0.0, sin(pi * (hour - 6) / 13));
  }
}
