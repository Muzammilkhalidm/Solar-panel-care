import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../data/datasources/remote/weather_api_datasource.dart';
import '../../domain/entities/weather_info.dart';
import '../../state/alerts_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/panels_provider.dart';
import 'widgets/dashboard_greeting.dart';
import 'widgets/energy_gauge_card.dart';
import 'widgets/live_readings_grid.dart';
import 'widgets/panels_preview_strip.dart';
import 'widgets/quick_actions_row.dart';
import 'widgets/system_insights_card.dart';
import 'widgets/system_power_chart.dart';
import 'widgets/system_status_card.dart';
import 'widgets/weather_banner.dart';

/// Home tab: premium Voltix-style dashboard, everything at a glance.
/// Developed by Panel Care Team 7-H.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  WeatherInfo? _weather;
  bool _weatherLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final WeatherInfo info = await WeatherApiDatasource().getWeather();
      if (!mounted) return;
      setState(() {
        _weather = info;
        _weatherLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _weatherLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final panels = context.watch<PanelsProvider>();
    final alerts = context.watch<AlertsProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeController>();
    final AppPalette p = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: DashboardGreeting(
          name: auth.user?.name ?? 'Solar Owner',
          greeting: AppDateTimeUtils.greeting(),
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle dark / light',
            onPressed: () => theme.toggleLightDark(),
            icon: Icon(
              theme.isDarkNow ? Icons.light_mode : Icons.dark_mode,
              color: const Color(0xFFFF7E2D),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.analytics),
                icon: const Icon(Icons.insights_outlined),
              ),
              if (alerts.criticalCount > 0)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5484D),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFF7E2D),
        onRefresh: () async {
          await context.read<PanelsProvider>().refresh();
          await _loadWeather();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
          children: [
            // 1) Hero: photo, system output, master switch, eco chips.
            const SystemStatusCard(),
            const SizedBox(height: 16),
            // 2) Today's energy gauge + week/month/savings.
            const EnergyGaugeCard(),
            const SizedBox(height: 16),
            // 3) Voltix-style insight rows.
            const SystemInsightsCard(),
            const SizedBox(height: 16),
            // 4) Live electrical readings.
            LiveReadingsGrid(),
            const SizedBox(height: 16),
            // 5) Quick actions (Register Plate = primary).
            QuickActionsRow(
              onSimulateFault: () async {
                final ok = await context
                    .read<PanelsProvider>()
                    .simulateRandomFault();
                if (!mounted) return;
                AppSnackBar.info(
                  ok
                      ? 'Fault injected! Alert + alarm flow is running…'
                      : 'No healthy powered plate available to damage.',
                );
              },
              onShutdownAll: () async {
                await context.read<PanelsProvider>().setSystemPower(false);
                if (!mounted) return;
                AppSnackBar.warning('All plates powered OFF');
              },
              onAddPanel: () =>
                  Navigator.pushNamed(context, AppRoutes.addPanel),
              onAnalytics: () =>
                  Navigator.pushNamed(context, AppRoutes.analytics),
            ),
            const SizedBox(height: 16),
            // 6) Plates strip.
            PanelsPreviewStrip(),
            const SizedBox(height: 16),
            // 7) Weather.
            WeatherBanner(
              weather: _weather,
              loading: _weatherLoading,
            ),
            const SizedBox(height: 16),
            // 8) Live performance bars.
            const SystemPowerChart(),
            const SizedBox(height: 14),
            Text(
              'IoT reading cycle: every 4 seconds • '
              '${panels.producingCount}/${panels.total} plates producing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: p.textFaint,
              ),
            ),
            const SizedBox(height: 18),
            // Team credit — Developed by Panel Care Team 7-H
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: p.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        gradient: AppColorsX.energyGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.solar_power,
                          size: 13, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppConstants.developerCredit,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: p.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Local alias so the dashboard can use the brand gradient directly.
class AppColorsX {
  AppColorsX._();
  static const energyGradient = LinearGradient(
    colors: [Color(0xFFFFC65C), Color(0xFFF7A021), Color(0xFFFF7E2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
