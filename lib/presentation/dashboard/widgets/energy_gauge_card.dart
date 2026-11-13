import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../state/stats_provider.dart';

/// "Today's Energy Overview" gauge — semi-circular amber energy arc with
/// the live kWh number in the center, plus week / month / savings metrics.
class EnergyGaugeCard extends StatelessWidget {
  const EnergyGaugeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final stats = context.watch<StatsProvider>().stats;

    // Percent of a realistic daily target (kWh) used to fill the gauge.
    const double dailyTargetKwh = 30;
    final double today = stats?.todayKwh ?? 0;
    double pct = (today / dailyTargetKwh * 100).clamp(0, 100).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
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
                  "Today's Energy Overview",
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
                child: Text(
                  'Target ${dailyTargetKwh.toStringAsFixed(0)} kWh',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: p.textFaint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 168,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 135,
                    sectionsSpace: 0,
                    centerSpaceRadius: 62,
                    pieTouchData: PieTouchData(enabled: false),
                    sections: _gaugeSections(pct, p.chartGrid),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppFormatters.kwh(today),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: p.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Text(
                      'produced today',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: p.textFaint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Metric(
                label: 'This Week',
                value: stats == null ? '—' : AppFormatters.kwh(stats.weekKwh),
                icon: Icons.calendar_view_week,
              ),
              const SizedBox(width: 10),
              _Metric(
                label: 'This Month',
                value: stats == null ? '—' : AppFormatters.kwh(stats.monthKwh),
                icon: Icons.calendar_month,
              ),
              const SizedBox(width: 10),
              _Metric(
                label: 'Saved Today',
                value: stats == null
                    ? '—'
                    : 'Rs ${stats.moneySavedPkr.toStringAsFixed(0)}',
                icon: Icons.savings_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 270° arc: value sweep (3-step gradient), remaining track, bottom gap.
  List<PieChartSectionData> _gaugeSections(double pct, Color trackColor) {
    const Color glow = Color(0xFFFFC65C);
    const Color amber = Color(0xFFF7A021);
    const Color orange = Color(0xFFFF7E2D);

    final double filled = 0.75 * pct;
    final double rest = 75 - filled;

    List<PieChartSectionData> sections = [];

    if (filled >= 0.4) {
      // Split the value arc into three bands for a gradient sweep.
      final double third = filled / 3;
      sections.add(_section(third, glow));
      sections.add(_section(third, amber));
      sections.add(_section(third, orange));
    } else if (filled > 0) {
      sections.add(_section(filled, glow));
    }
    if (rest > 0.01) sections.add(_section(rest, trackColor));
    sections.add(PieChartSectionData(
      value: 25,
      color: Colors.transparent,
      showTitle: false,
    ));
    return sections;
  }

  PieChartSectionData _section(double value, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 13,
      showTitle: false,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: p.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: const Color(0xFFFF7E2D)),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: p.textPrimary,
                ),
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
