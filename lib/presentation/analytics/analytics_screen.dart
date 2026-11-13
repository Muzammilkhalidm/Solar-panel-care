import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/section_header.dart';
import '../../state/stats_provider.dart';
import '../common/image_banner.dart';
import 'widgets/efficiency_trend_chart.dart';
import 'widgets/panel_comparison_chart.dart';
import 'widgets/savings_summary_card.dart';
import 'widgets/weekly_energy_chart.dart';

/// Analytics & savings tab (pushed from dashboard quick actions).
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>().stats;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & Savings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
        children: [
          const SavingsSummaryCard(),
          const SizedBox(height: 16),
          const SectionHeader(
            title: 'Energy — Last 7 Days',
            subtitle: 'kWh per day (today is live)',
          ),
          const WeeklyEnergyChart(),
          const SizedBox(height: 16),
          const SectionHeader(
            title: 'System Efficiency Trend',
            subtitle: 'Rolling average efficiency of producing plates',
          ),
          const EfficiencyTrendChart(),
          const SizedBox(height: 16),
          const SectionHeader(
            title: 'Plate Comparison (Today)',
            subtitle: 'Which plate is carrying the system?',
          ),
          const PanelComparisonChart(),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoTile(
                label: 'Peak Power',
                value: stats == null
                    ? '—'
                    : AppFormatters.watts(stats.peakPowerW),
                icon: Icons.speed,
              ),
              const SizedBox(width: 10),
              _InfoTile(
                label: 'Avg Efficiency',
                value: stats == null
                    ? '—'
                    : AppFormatters.percent(stats.avgEfficiency),
                icon: Icons.percent,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ImageBanner(
            asset: AppAssets.imgControlRoom,
            height: 110,
            borderRadius: 18,
            children: [
              Text(
                'Data source',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              Text(
                'Per-plate IoT readings every 4 seconds, aggregated on-device. '
                'Weekly history persists locally.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFFF7A021)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: p.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 10.5, color: p.textFaint),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
