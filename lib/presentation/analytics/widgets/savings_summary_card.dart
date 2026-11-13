import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/section_header.dart';
import '../../../state/stats_provider.dart';

/// Money / CO2 / trees saved summary.
class SavingsSummaryCard extends StatelessWidget {
  const SavingsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>().stats;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E9E5B), Color(0xFF1B5E20)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E9E5B).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL SAVED TODAY',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stats == null ? '—' : AppFormatters.pkr(stats.moneySavedPkr),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stats == null
                    ? 'Loading energy data…'
                    : 'from ${AppFormatters.kwh(stats.todayKwh)} produced today',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _GreenTile(
              icon: Icons.co2,
              label: 'CO2 Avoided',
              value: stats == null
                  ? '—'
                  : '${stats.co2SavedKg.toStringAsFixed(1)} kg',
            ),
            const SizedBox(width: 10),
            _GreenTile(
              icon: Icons.forest,
              label: 'Tree-Years',
              value: stats == null ? '—' : '${stats.treesEquivalent}',
            ),
            const SizedBox(width: 10),
            _GreenTile(
              icon: Icons.battery_charging_full,
              label: 'Lifetime',
              value: stats == null
                  ? '—'
                  : AppFormatters.kwh(stats.lifetimeKwh),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const SectionHeader(
          title: 'Why savings matter',
          subtitle:
              'Free sunlight = koi bijli ka bill nahi. Har kWh saved is money '
              'in your pocket and less CO2 in the air.',
        ),
      ],
    );
  }
}

class _GreenTile extends StatelessWidget {
  const _GreenTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: p.successSoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 19, color: const Color(0xFF2E9E5B)),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: p.textPrimary,
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9.5, color: p.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
