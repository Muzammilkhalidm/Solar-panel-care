import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/panel.dart';

/// Line chart of the plate's rolling reading history.
class PanelPowerChart extends StatelessWidget {
  const PanelPowerChart({super.key, required this.panel});

  final Panel panel;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final history = panel.history;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.cardBorder),
      ),
      child: history.length < 2
          ? SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  'Collecting live readings…',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
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
                            reservedSize: 42,
                            getTitlesWidget: (v, meta) => Text(
                              v.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 9,
                                color: p.chartAxisText,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            interval:
                                (history.length / 4).clamp(1, 12).toDouble(),
                            getTitlesWidget: (v, meta) {
                              final int idx = v.toInt();
                              if (idx < 0 || idx >= history.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  AppFormatters.time(history[idx].timestamp),
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    color: p.chartAxisText,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => context.isDark
                              ? const Color(0xFF2E2A20)
                              : const Color(0xFF211E17),
                          getTooltipItems: (spots) => spots
                              .map((s) => LineTooltipItem(
                                    AppFormatters.watts(s.y),
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            history.length,
                            (i) => FlSpot(i.toDouble(), history[i].power),
                          ),
                          isCurved: true,
                          barWidth: 2.4,
                          color: const Color(0xFF2E9E5B),
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF2E9E5B).withOpacity(0.25),
                                const Color(0xFF2E9E5B).withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${history.length} readings in memory • '
                  'last: ${AppFormatters.time(history.last.timestamp)}',
                  style: TextStyle(fontSize: 10, color: p.textFaint),
                ),
              ],
            ),
    );
  }
}
