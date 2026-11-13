import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../state/stats_provider.dart';

/// "Energy Performance" — rounded amber-gradient bars of the rolling
/// system snapshots (live, updates every IoT cycle).
class SystemPowerChart extends StatelessWidget {
  const SystemPowerChart({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final history = context.watch<StatsProvider>().systemHistory;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: p.cardBorder),
        boxShadow: p.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Energy Performance',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF7E2D),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE • 4s cycles',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: p.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: history.length < 2
                ? Center(
                    child: Text(
                      'Collecting live data…',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : BarChart(
                    BarChartData(
                      maxY: _maxY(history),
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => context.isDark
                              ? const Color(0xFF2E2A20)
                              : const Color(0xFF211E17),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                              BarTooltipItem(
                            AppFormatters.watts(rod.toY),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: p.chartGrid,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (v, meta) {
                              final int idx = v.toInt();
                              if (idx < 0 || idx >= history.length) {
                                return const SizedBox.shrink();
                              }
                              // Show only ~4 time labels.
                              final int step =
                                  (history.length / 4).ceil().clamp(1, 99);
                              if (idx % step != 0 && idx != history.length - 1) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  AppFormatters.time(history[idx].timestamp),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: p.chartAxisText,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(history.length, (i) {
                        final double maxP = _maxY(history);
                        final double t = maxP <= 0
                            ? 0.0
                            : (history[i].power / maxP).clamp(0.0, 1.0).toDouble();
                        // Amber → orange gradient by height (like Voltix bars).
                        final Color barColor = Color.lerp(
                          const Color(0xFFFFD98A),
                          const Color(0xFFFF7E2D),
                          t.clamp(0, 1),
                        )!;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: history[i].power,
                              width: 9,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  barColor.withOpacity(0.55),
                                  barColor,
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  double _maxY(List<dynamic> history) {
    double m = 0;
    for (final h in history) {
      if (h.power > m) m = h.power;
    }
    if (m <= 0) return 10;
    // Round up to a nice ceiling.
    final double scale = m >= 1000 ? 500 : 100;
    return (m / scale).ceilToDouble() * scale * 1.15;
  }
}
