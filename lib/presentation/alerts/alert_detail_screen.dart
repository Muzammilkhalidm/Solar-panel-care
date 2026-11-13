import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/stat_tile.dart';
import '../../domain/entities/alert.dart';
import '../../state/alerts_provider.dart';
import '../../state/panels_provider.dart';
import '../common/image_banner.dart';
import 'widgets/severity_badge.dart';
import '../../domain/entities/panel_fault.dart';

/// Full alert detail with snapshot, guidance and repair actions.
class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final alerts = context.watch<AlertsProvider>();
    final Alert? alert = alerts.alerts
        .where((a) => a.id == alertId)
        .cast<Alert?>()
        .firstOrNull ??
        alerts.alerts.firstOrNull;

    if (alert == null) {
      return const Scaffold(
        body: Center(child: Text('Alert not found.')),
      );
    }

    final Map<String, dynamic> snap = alert.snapshot;

    return Scaffold(
      appBar: AppBar(title: const Text('Alert Detail')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          ImageBanner(
            asset: AppAssets.imgInspection,
            height: 130,
            borderRadius: 20,
            children: [
              Row(
                children: [
                  SeverityBadge(severity: alert.severity),
                  const SizedBox(width: 10),
                  Text(
                    alert.type.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                AppFormatters.dateTime(alert.createdAt),
                style: const TextStyle(
                    color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            alert.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.solar_power, size: 15, color: p.textFaint),
              const SizedBox(width: 5),
              Text(
                '${alert.panelName} • device alert',
                style: TextStyle(fontSize: 12, color: p.textSecondary),
              ),
              const Spacer(),
              if (alert.resolved)
                const Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 14, color: Color(0xFF2E9E5B)),
                    SizedBox(width: 4),
                    Text(
                      'Resolved',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E9E5B),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            alert.message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          if (snap.isNotEmpty) ...[
            Text(
              'Readings at Alert Time',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Power',
                    value:
                        '${((snap['power'] as num?) ?? 0).toStringAsFixed(0)} W',
                    icon: Icons.bolt,
                    color: const Color(0xFFF7A021),
                    compact: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    label: 'Voltage',
                    value:
                        '${((snap['voltage'] as num?) ?? 0).toStringAsFixed(1)} V',
                    icon: Icons.electrical_services,
                    color: const Color(0xFF2E7DD1),
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Temperature',
                    value:
                        '${((snap['temperature'] as num?) ?? 0).toStringAsFixed(1)}°C',
                    icon: Icons.device_thermostat,
                    color: const Color(0xFFE5484D),
                    compact: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    label: 'Health',
                    value: '${((snap['health'] as num?) ?? 0).toStringAsFixed(0)}%',
                    icon: Icons.favorite,
                    color: const Color(0xFF2E9E5B),
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
          Text(
            'What Should You Do?',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: p.infoSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.35)),
            ),
            child: Text(
              alert.faultType.recommendation,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: p.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (alert.isActive) ...[
            AppButton(
              label: 'Request Technician Visit',
              icon: Icons.support_agent,
              onPressed: () async {
                final record = await context
                    .read<AlertsProvider>()
                    .requestTechnician(alert);
                await context.read<PanelsProvider>().refresh();
                if (!context.mounted) return;
                AppSnackBar.info(
                  record == null
                      ? 'Could not schedule the visit.'
                      : 'Visit scheduled — the plate will be repaired/replaced.',
                );
              },
            ),
            const SizedBox(height: 10),
            AppGhostButton(
              label: 'Mark As Resolved',
              icon: Icons.check_circle_outline,
              onPressed: () async {
                await context.read<AlertsProvider>().resolve(alert.id);
                if (!context.mounted) return;
                AppSnackBar.success('Alert resolved.');
                Navigator.maybePop(context);
              },
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: p.successSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Resolved ${alert.resolvedAt == null ? "" : AppFormatters.timeAgo(alert.resolvedAt!)} — '
                'plate returned to normal service.',
                style: TextStyle(fontSize: 12, color: p.textPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
