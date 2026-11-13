import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/entities/panel.dart';
import '../../../state/panels_provider.dart';

/// Per-plate switch row with live output.
class PanelSwitchTile extends StatelessWidget {
  const PanelSwitchTile({super.key, required this.panel});

  final Panel panel;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: panel.isFaulted
              ? const Color(0xFFE5484D).withOpacity(0.5)
              : p.cardBorder,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              AppAssets.panelPhotos[
                  panel.photoSeed % AppAssets.panelPhotos.length],
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  panel.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    statusBadgeFor(panel.status.name, compact: true),
                    const SizedBox(width: 8),
                    Text(
                      panel.isProducing
                          ? AppFormatters.watts(panel.power)
                          : (panel.powerEnabled ? 'idle' : 'off'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: p.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: panel.powerEnabled,
            onChanged: panel.status == PanelStatus.maintenance
                ? null
                : (v) =>
                    context.read<PanelsProvider>().togglePower(panel.id),
            activeTrackColor: const Color(0xFFF7A021),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
