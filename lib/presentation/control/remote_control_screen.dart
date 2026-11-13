import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/pulse_dot.dart';
import '../../core/widgets/section_header.dart';
import '../../domain/entities/panel.dart';
import '../../state/panels_provider.dart';
import '../../state/settings_provider.dart';
import '../common/image_banner.dart';
import 'widgets/emergency_shutdown_button.dart';
import 'widgets/master_switch_card.dart';
import 'widgets/panel_switch_tile.dart';
import 'widgets/auto_schedule_card.dart';

/// Remote control tab: master switch, per-plate switches, emergency stop.
class RemoteControlScreen extends StatelessWidget {
  const RemoteControlScreen({super.key});

  Future<void> _emergencyShutdown(BuildContext context) async {
    final bool ok = await AppDialog.confirm(
      context,
      title: 'EMERGENCY SHUTDOWN',
      message:
          'Every plate and the inverter line will be powered OFF immediately. '
          'Use this for fire, storm or maintenance situations.',
      confirmLabel: 'Shutdown Everything',
      danger: true,
    );
    if (!ok) return;
    await context.read<PanelsProvider>().setSystemPower(false);
    if (!context.mounted) return;
    AppSnackBar.warning(
        'Emergency shutdown complete — all plates are OFF.');
  }

  @override
  Widget build(BuildContext context) {
    final panels = context.watch<PanelsProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remote Control',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  PulseDot(
                    color: panels.systemOn
                        ? const Color(0xFF2E9E5B)
                        : const Color(0xFF8A94A6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    panels.systemOn ? 'SYSTEM ON' : 'SYSTEM OFF',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
        children: [
          MasterSwitchCard(),
          const SizedBox(height: 16),
          EmergencyShutdownButton(onTap: () => _emergencyShutdown(context)),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'Individual Plates',
            subtitle: 'Har plate ka apna switch — ON/OFF from anywhere',
          ),
          ...panels.panels.map(
            (panel) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PanelSwitchTile(panel: panel),
            ),
          ),
          const SizedBox(height: 12),
          ImageBanner(
            asset: AppAssets.imgCleaning,
            height: 110,
            borderRadius: 18,
            children: [
              Text(
                'Maintenance tip',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              Text(
                'Turn the plate OFF before cleaning — safer for you, '
                'better readings for the IoT device.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AutoScheduleCard(enabled: settings.settings.autoScheduleEnabled),
          const SizedBox(height: 12),
          Text(
            'Current output: ${AppFormatters.watts(panels.totalPowerNow)} • '
            'Today: ${AppFormatters.kwh(panels.todayKwh)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: context.palette.textFaint),
          ),
        ],
      ),
    );
  }
}
