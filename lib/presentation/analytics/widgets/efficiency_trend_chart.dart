import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../state/stats_provider.dart';

/// Efficiency line chart from the rolling system snapshots.
class EfficiencyTrendChart extends StatelessWidget {
  const EfficiencyTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final history = context.watch<StatsProvider>().systemHistory;
    final points = history
        .where((r) => r.efficiency > 0)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.cardBorder),
      ),
      child: points.length < 2
          ? SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Collecting efficiency data…',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
          : SizedBox(
              height: 170,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
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
                        reservedSize: 32,
                        getTitlesWidget: (v, meta) => Text(
                          '${v.toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 9, color: p.chartAxisText),
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        points.length,
                        (i) => FlSpot(i.toDouble(), points[i].efficiency),
                      ),
                      isCurved: true,
                      barWidth: 2.6,
                      color: const Color(0xFF9C27B0),
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF9C27B0).withOpacity(0.22),
                            const Color(0xFF9C27B0).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
