import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../state/alerts_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/iot_connection_provider.dart';
import '../../state/panels_provider.dart';
import '../../state/settings_provider.dart';
import '../../state/stats_provider.dart';
import '../common/image_banner.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_tile.dart';
import 'widgets/theme_mode_selector.dart';
import '../../core/constants/app_assets.dart';

/// Settings tab.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final link = context.watch<IotConnectionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
        children: [
          // Profile card
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E2A20), Color(0xFF1D1B17)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E241C08),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFF7A021),
                    child: Text(
                      (auth.user?.name.isNotEmpty ?? false)
                          ? auth.user!.name[0].toUpperCase()
                          : 'S',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.name ?? 'Solar Owner',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.user?.email ?? '—',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white70),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          SettingsGroup(
            title: 'Appearance',
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: ThemeModeSelector(),
              ),
              const SizedBox(height: 10),
            ],
          ),

          SettingsGroup(
            title: 'Alerts & Notifications',
            children: [
              SettingsSwitchTile(
                icon: Icons.notifications_active,
                title: 'Notifications',
                subtitle: 'Show fault alerts as banners',
                value: settings.settings.notificationsEnabled,
                onChanged: (v) => settings.setNotifications(v),
              ),
              SettingsSwitchTile(
                icon: Icons.alarm,
                title: 'Alarm Sound',
                subtitle: 'Loud siren for critical plate damage',
                value: settings.settings.alarmSoundEnabled,
                onChanged: (v) => settings.setAlarmSound(v),
              ),
              SettingsSwitchTile(
                icon: Icons.vibration,
                title: 'Vibration',
                subtitle: 'Heavy vibration pattern on critical alerts',
                value: settings.settings.vibrationEnabled,
                onChanged: (v) => settings.setVibration(v),
              ),
              SettingsTile(
                icon: Icons.music_note,
                title: 'Test Alarm',
                subtitle: '3-second preview of the emergency siren',
                onTap: () async {
                  await settings.testAlarm();
                  if (!context.mounted) return;
                  AppSnackBar.info('Alarm test finished.');
                },
              ),
              SettingsSliderTile(
                icon: Icons.device_thermostat,
                title: 'Temperature Limit',
                subtitle:
                    'Alert when a plate crosses this cell temperature.',
                value: settings.settings.temperatureThreshold,
                min: 50,
                max: 95,
                suffix: '°C',
                onChanged: (v) => settings.setTemperatureThreshold(v),
              ),
              SettingsSliderTile(
                icon: Icons.speed,
                title: 'Performance Limit',
                subtitle:
                    'Alert when efficiency drops below this percentage.',
                value: settings.settings.performanceThreshold,
                min: 25,
                max: 85,
                suffix: '%',
                onChanged: (v) => settings.setPerformanceThreshold(v),
              ),
            ],
          ),

          SettingsGroup(
            title: 'IoT Device & Demo',
            children: [
              SettingsSwitchTile(
                icon: Icons.wb_sunny,
                title: 'Demo Sun',
                subtitle:
                    'Keep plates producing even at night (great for demos)',
                value: settings.settings.forceSunlight,
                onChanged: (v) => settings.setForceSunlight(v),
              ),
              SettingsSwitchTile(
                icon: Icons.shield,
                title: 'Auto-Shutdown on Critical Fault',
                subtitle:
                    'Automatically cut a damaged plate to protect the array',
                value: settings.settings.autoShutdownOnFault,
                onChanged: (v) => settings.setAutoShutdown(v),
              ),
              SettingsTile(
                icon: link.isConnected
                    ? Icons.link_off
                    : Icons.link,
                title: link.isConnected
                    ? 'Simulate Hub Disconnect'
                    : 'Reconnect IoT Hub',
                subtitle: 'Status: ${link.stateLabel} • ticks: ${link.ticks}',
                onTap: () async {
                  if (link.isConnected) {
                    await link.simulateDisconnect();
                  } else {
                    await link.reconnect();
                  }
                },
              ),
            ],
          ),

          SettingsGroup(
            title: 'About & Support',
            children: [
              SettingsTile(
                icon: Icons.info_outline,
                title: 'About Solar Panel Care',
                subtitle: 'Version ${AppConstants.appVersion}',
                onTap: () => Navigator.pushNamed(context, AppRoutes.about),
              ),
              SettingsTile(
                icon: Icons.restore,
                title: 'Reset Demo Data',
                subtitle:
                    'Factory system: 8 plates, clean alerts, default settings',
                onTap: () => _resetDemo(context),
              ),
              SettingsTile(
                icon: Icons.logout,
                title: 'Log Out',
                subtitle: 'Signed in as ${auth.user?.email ?? "—"}',
                danger: true,
                onTap: () => _logout(context),
              ),
            ],
          ),

          ImageBanner(
            asset: AppAssets.imgInspection,
            height: 100,
            borderRadius: 18,
            children: [
              Text(
                'Solar Panel Care • ${AppConstants.appTagline}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
              const Text(
                AppConstants.developerCredit,
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _resetDemo(BuildContext context) async {
    final bool ok = await AppDialog.confirm(
      context,
      title: 'Reset demo data?',
      message:
          'All plates, alerts and settings return to the factory demo state. '
          'This cannot be undone.',
      confirmLabel: 'Reset',
      danger: true,
    );
    if (!ok) return;
    await context.read<PanelsProvider>().resetDemoSystem();
    await context.read<AlertsProvider>().clearAll();
    await context.read<SettingsProvider>().reset();
    await context.read<StatsProvider>().refresh();
    if (!context.mounted) return;
    AppSnackBar.success('Demo data restored to factory state.');
  }

  Future<void> _logout(BuildContext context) async {
    final bool ok = await AppDialog.confirm(
      context,
      title: 'Log out?',
      message: 'You will need to sign in again to monitor your plates.',
      confirmLabel: 'Log Out',
      danger: true,
    );
    if (!ok) return;

    // Stop everything cleanly.
    context.read<AlertsProvider>().stopAlarm();
    await context.read<AuthProvider>().signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
  }
}
