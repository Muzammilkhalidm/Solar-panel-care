import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../domain/entities/maintenance_record.dart';
import '../../../domain/entities/panel.dart';
import '../../../state/panels_provider.dart';
import '../../../domain/entities/panel_fault.dart';

/// Red fault card with description, guidance and repair actions.
class FaultBannerCard extends StatelessWidget {
  const FaultBannerCard({super.key, required this.panel});

  final Panel panel;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.dangerSoft,
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: const Color(0xFFE5484D).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppAssets.imgDamaged,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.report,
                            color: Color(0xFFE5484D), size: 19),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            panel.activeFault.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14.5,
                              color: Color(0xFFE5484D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Health ${panel.healthScore}% • Output '
                      '${panel.power.toStringAsFixed(0)} W',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: p.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            panel.activeFault.description,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: p.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: p.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Recommendation: ${panel.activeFault.recommendation}',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: p.textSecondary,
              ),
            ),
          ),
          if (panel.activeFault.isCritical) ...[
            const SizedBox(height: 8),
            Text(
              AppConstants.cascadeWarning,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE5484D),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Mark Repaired',
                  icon: Icons.build_circle,
                  backgroundColor: const Color(0xFF2E9E5B),
                  onPressed: () async {
                    await context
                        .read<PanelsProvider>()
                        .markRepaired(panel.id);
                    if (!context.mounted) return;
                    AppSnackBar.success(
                        '${panel.name} restored to service.');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppGhostButton(
                  label: 'Request Technician',
                  icon: Icons.support_agent,
                  onPressed: () async {
                    await context
                        .read<PanelsProvider>()
                        .scheduleMaintenance(
                          panel.id,
                          MaintenanceType.repair,
                          'Technician requested for '
                          '${panel.activeFault.label} via plate screen.',
                        );
                    if (!context.mounted) return;
                    AppSnackBar.info(
                        'Technician request scheduled for ${panel.name}.');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
