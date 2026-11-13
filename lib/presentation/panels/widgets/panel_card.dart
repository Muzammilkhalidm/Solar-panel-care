import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/entities/panel.dart';

/// Card for a single solar plate (dashboard strip + panels list).
class PanelCard extends StatelessWidget {
  const PanelCard({
    super.key,
    required this.panel,
    this.width,
  });

  final Panel panel;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final String photo = AppAssets.panelPhotos[panel.photoSeed % AppAssets.panelPhotos.length];
    final bool faulted = panel.isFaulted;
    final Color statusColor =
        faulted ? const Color(0xFFE5484D) : _statusColor(panel);

    final Widget card = Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: faulted ? const Color(0xFFE5484D).withOpacity(0.55) : p.cardBorder,
          width: faulted ? 1.4 : 1,
        ),
        boxShadow: p.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  faulted ? AppAssets.imgDamaged : photo,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      panel.deviceId,
                      style: TextStyle(
                        fontSize: 10,
                        color: p.textFaint,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          statusBadgeFor(
            faulted ? 'fault' : panel.status.name,
            compact: true,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.watts(panel.power),
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: statusColor,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Health ${panel.healthScore}%',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: p.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppFormatters.kwh(panel.energyTodayKwh),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: p.textFaint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.panelDetail,
        arguments: panel.id,
      ),
      child: card,
    );
  }

  Color _statusColor(Panel panel) {
    switch (panel.status) {
      case PanelStatus.online:
        return const Color(0xFF2E9E5B);
      case PanelStatus.offline:
        return const Color(0xFF8A94A6);
      case PanelStatus.maintenance:
        return const Color(0xFFF5A524);
      case PanelStatus.off:
        return const Color(0xFF64748B);
      case PanelStatus.fault:
        return const Color(0xFFE5484D);
    }
  }
}
