import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../state/settings_provider.dart';

/// Fake sunrise/sunset automation card.
class AutoScheduleCard extends StatelessWidget {
  const AutoScheduleCard({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF7A021).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule,
                size: 20, color: Color(0xFFFF7E2D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto Schedule (Sunrise / Sunset)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  enabled
                      ? 'Auto ON 06:00 • Auto OFF 19:00 • every day'
                      : 'System runs manually — enable for automatic schedule',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: p.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (v) =>
                context.read<SettingsProvider>().setAutoSchedule(v),
            activeTrackColor: const Color(0xFFF7A021),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
