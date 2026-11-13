import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../state/stats_provider.dart';

/// Bar chart of the last 7 days (kWh).
class WeeklyEnergyChart extends StatelessWidget {
  const WeeklyEnergyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final weekly = context.watch<StatsProvider>().weeklyEnergy;

    if (weekly.length != 7) {
      return const SizedBox.shrink();
    }

    final DateTime now = DateTime.now();
    final List<String> labels = List.generate(7, (i) {
      final DateTime day = now.subtract(Duration(days: 6 - i));
      return AppDateTimeUtilsLabel.dayLabel(day.weekday);
    });

    final double maxY =
        weekly.fold(0.0, (m, v) => v > m ? v : m) * 1.25;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.cardBorder),
      ),
      child: SizedBox(
        height: 190,
        child: BarChart(
          BarChartData(
            maxY: maxY <= 0 ? 10 : maxY,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (v) => FlLine(
                color: p.chartGrid,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  getTitlesWidget: (v, meta) => Text(
                    v.toStringAsFixed(0),
                    style: TextStyle(fontSize: 9, color: p.chartAxisText),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (v, meta) {
                    final int idx = v.toInt();
                    if (idx < 0 || idx > 6) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        labels[idx],
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: idx == 6
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: idx == 6
                              ? const Color(0xFFF7A021)
                              : p.chartAxisText,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => context.isDark
                    ? const Color(0xFF2E2A20)
                    : const Color(0xFF211E17),
                getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                  AppFormatters.kwh(rod.toY),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            barGroups: List.generate(7, (i) {
              final bool isToday = i == 6;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: weekly[i],
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6)),
                    color: isToday
                        ? const Color(0xFFF7A021)
                        : const Color(0xFF2E7DD1).withOpacity(0.65),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Local alias to keep the day-label call site tidy.
class AppDateTimeUtilsLabel {
  static String dayLabel(int weekday) {
    const List<String> names = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    return names[(weekday - 1).clamp(0, 6)];
  }
}
