import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_header.dart';
import '../../domain/entities/alert.dart';
import '../../state/alerts_provider.dart';
import 'widgets/active_alarm_card.dart';
import 'widgets/alert_filter_bar.dart';
import 'widgets/alert_tile.dart';
import 'widgets/severity_badge.dart';
import '../../core/constants/app_strings.dart';

/// Opens the alert detail screen for a given alert.
void openAlertDetail(BuildContext context, Alert alert) {
  Navigator.pushNamed(
    context,
    AppRoutes.alertDetail,
    arguments: alert.id,
  );
}

enum _AlertTab { all, active, critical, resolved }

/// Alerts tab: emergency banner, filters and the alert history.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final alerts = context.watch<AlertsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alerts (${alerts.activeCount} active)',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (alerts.resolvedAlerts.isNotEmpty)
            IconButton(
              tooltip: 'Clear resolved history',
              onPressed: () =>
                  context.read<AlertsProvider>().clearResolved(),
              icon: const Icon(Icons.cleaning_services_outlined, size: 20),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: AlertsBody(alerts: alerts),
      floatingActionButton: alerts.activeCount > 0
          ? null
          : FloatingActionButton.extended(
              heroTag: 'about',
              backgroundColor: const Color(0xFFF7A021),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text('System Healthy'),
              onPressed: () {},
            ),
    );
  }
}

/// Separated body widget so the whole list rebuilds on provider updates.
class AlertsBody extends StatefulWidget {
  const AlertsBody({super.key, required this.alerts});

  final AlertsProvider alerts;

  @override
  State<AlertsBody> createState() => _AlertsBodyState();
}

class _AlertsBodyState extends State<AlertsBody> {
  _AlertTab _tab = _AlertTab.all;

  List<Alert> get _filtered {
    switch (_tab) {
      case _AlertTab.all:
        return widget.alerts.alerts;
      case _AlertTab.active:
        return widget.alerts.activeAlerts;
      case _AlertTab.critical:
        return widget.alerts.activeAlerts
            .where((a) =>
                a.severity == AlertSeverity.critical ||
                a.severity == AlertSeverity.high)
            .toList();
      case _AlertTab.resolved:
        return widget.alerts.resolvedAlerts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final list = _filtered;

    return RefreshIndicator(
      onRefresh: () => context.read<AlertsProvider>().refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          if (widget.alerts.activeAlerts.isNotEmpty) ...[
            ActiveAlarmCard(alert: widget.alerts.loudestActiveAlert!),
            const SizedBox(height: 14),
          ],
          SectionHeader(
            title: 'Alert History',
            subtitle: 'Tap an alert for full guidance and repair actions',
          ),
          AlertFilterBar(
            labels: _AlertTab.values.map((t) => _label(t)).toList(),
            selectedIndex: _AlertTab.values.indexOf(_tab),
            onSelect: (i) => setState(() => _tab = _AlertTab.values[i]),
          ),
          const SizedBox(height: 10),
          if (list.isEmpty)
            EmptyState(
              title: AppStrings.noAlertsTitle,
              message: AppStrings.noAlertsMessage,
              icon: Icons.verified_user_outlined,
            )
          else
            ...list.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AlertTile(alert: a),
              ),
            ),
          const SizedBox(height: 8),
          SeverityLegend(palette: p),
        ],
      ),
    );
  }

  String _label(_AlertTab t) {
    switch (t) {
      case _AlertTab.all:
        return 'All';
      case _AlertTab.active:
        return 'Active';
      case _AlertTab.critical:
        return 'Critical';
      case _AlertTab.resolved:
        return 'Resolved';
    }
  }
}

/// Small legend explaining the severity colors.
class SeverityLegend extends StatelessWidget {
  const SeverityLegend({super.key, required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final s in AlertSeverity.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: severityColor(s),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                s.label,
                style: TextStyle(fontSize: 10, color: palette.textFaint),
              ),
            ],
          ),
      ],
    );
  }
}
