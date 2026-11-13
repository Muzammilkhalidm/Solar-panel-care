import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/iot_simulation_engine.dart';
import '../../state/alerts_provider.dart';
import '../../state/iot_connection_provider.dart';
import '../../state/panels_provider.dart';
import '../../state/stats_provider.dart';
import '../alerts/alerts_screen.dart';
import '../control/remote_control_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../panels/panels_screen.dart';
import '../settings/settings_screen.dart';
import 'alarm_banner.dart';
import 'app_bottom_nav_bar.dart';

/// Persistent shell: bottom navigation + live alarm banner + engine owner.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  StreamSubscription<int>? _tickSub;

  final List<Widget> _tabs = const [
    DashboardScreen(),
    PanelsScreen(),
    RemoteControlScreen(),
    AlertsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSystem();
    });
  }

  Future<void> _startSystem() async {
    await context.read<PanelsProvider>().refresh();
    await context.read<AlertsProvider>().refresh();
    await context.read<StatsProvider>().refresh();
    await context.read<IotConnectionProvider>().connect();

    // Start the IoT heartbeat (starts only once even on hot reload).
    final engine = context.read<IotSimulationEngine>();
    if (!engine.isRunning) await engine.start();

    // System-wide chart + live tiles + alerts refresh on every tick.
    _tickSub = engine.tickStream.listen((_) {
      if (!mounted) return;
      context.read<StatsProvider>().refresh();
      context.read<PanelsProvider>().refresh();
      context.read<AlertsProvider>().refresh();
    });
  }

  @override
  void dispose() {
    _tickSub?.cancel();
    super.dispose();
  }

  void _onTab(int i) {
    setState(() => _index = i);
    if (i == 0) context.read<StatsProvider>().refresh();
    if (i == 1) context.read<PanelsProvider>().refresh();
    if (i == 3) context.read<AlertsProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertsProvider>();

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _tabs),
          // Emergency banner slides over everything while alarm rings.
          if (alerts.alarmRinging || alerts.criticalCount > 0)
            AlarmBanner(alert: alerts.loudestActiveAlert),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        alertBadge: alerts.activeCount,
        onTap: _onTab,
      ),
    );
  }
}
