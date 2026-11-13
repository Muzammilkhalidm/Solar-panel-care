import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../state/panels_provider.dart';
import '../../../state/stats_provider.dart';

/// "System Insights" — premium icon rows summarising the whole system,
/// mirroring the Voltix insights list.
class SystemInsightsCard extends StatelessWidget {
  const SystemInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final stats = context.watch<StatsProvider>().stats;
    final panels = context.watch<PanelsProvider>();

    final double efficiency = stats?.avgEfficiency ?? 0;
    final double peakW = stats?.peakPowerW ?? 0;
    final double gridOffset = stats?.todayKwh ?? 0;
    final double health = panels.avgHealth;
    final double savings = stats?.moneySavedPkr ?? 0;

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
                  'System Insights',
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
                  'Live',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFF7E2D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InsightRow(
            icon: Icons.solar_power_outlined,
            tileColor: const Color(0xFFF7A021),
            label: 'Solar Efficiency',
            value: efficiency > 0 ? '${efficiency.toStringAsFixed(0)}%' : '—',
          ),
          _InsightRow(
            icon: Icons.electric_meter_outlined,
            tileColor: const Color(0xFF3B82F6),
            label: 'Grid Usage Offset',
            value: AppFormatters.kwh(gridOffset),
          ),
          _InsightRow(
            icon: Icons.health_and_safety_outlined,
            tileColor: const Color(0xFF3D9A50),
            label: 'Fleet Health',
            value: health > 0 ? '${health.toStringAsFixed(0)}%' : '—',
          ),
          _InsightRow(
            icon: Icons.bolt,
            tileColor: const Color(0xFFE85D04),
            label: 'Peak Output Today',
            value: peakW > 0 ? AppFormatters.watts(peakW) : '—',
          ),
          _InsightRow(
            icon: Icons.account_balance_wallet_outlined,
            tileColor: const Color(0xFF2E7DD1),
            label: 'Estimated Savings',
            value: 'Rs ${savings.toStringAsFixed(0)}',
            last: true,
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.tileColor,
    required this.label,
    required this.value,
    this.last = false,
  });

  final IconData icon;
  final Color tileColor;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      margin: EdgeInsets.only(bottom: last ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.surfaceAlt.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tileColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 17, color: tileColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: p.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: p.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
