import 'package:intl/intl.dart';

/// Formatting helpers for all monitoring values.
class AppFormatters {
  AppFormatters._();

  static String watts(double w) {
    if (w >= 1000) return '${(w / 1000).toStringAsFixed(2)} kW';
    return '${w.toStringAsFixed(0)} W';
  }

  static String kwh(double v) => '${v.toStringAsFixed(2)} kWh';

  static String pkr(double v) => 'PKR ${NumberFormat('#,##0').format(v)}';

  static String percent(double v) => '${v.toStringAsFixed(1)}%';

  static String volts(double v) => '${v.toStringAsFixed(1)} V';

  static String amps(double a) => '${a.toStringAsFixed(2)} A';

  static String celsius(double t) => '${t.toStringAsFixed(1)}°C';

  static String irradiance(double v) => '${v.toStringAsFixed(0)} W/m²';

  static String number(double v) => NumberFormat('#,##0.0').format(v);

  static String time(DateTime d) => DateFormat('HH:mm').format(d);

  static String date(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  static String dateTime(DateTime d) =>
      DateFormat('dd MMM yyyy, HH:mm').format(d);

  static String monthDay(DateTime d) => DateFormat('dd MMM').format(d);

  static String timeAgo(DateTime d) {
    final Duration diff = DateTime.now().difference(d);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    return date(d);
  }

  static String compact(int v) => NumberFormat.compact().format(v);
}
