import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/section_header.dart';
import '../../domain/entities/panel.dart';
import '../../domain/usecases/run_panel_diagnostics.dart';
import '../../state/panels_provider.dart';
import 'widgets/diagnostics_result_sheet.dart';
import 'widgets/fault_banner_card.dart';
import 'widgets/maintenance_tile.dart';
import 'widgets/panel_power_chart.dart';
import 'widgets/panel_readings_grid.dart';
import 'widgets/panel_status_chip.dart';
import '../../domain/entities/panel_fault.dart';
import '../../core/widgets/app_card.dart';

/// Deep view of one plate: live readings, chart, fault guidance,
/// diagnostics, remote switch and maintenance log.
class PanelDetailScreen extends StatefulWidget {
  const PanelDetailScreen({super.key, required this.panelId});

  final String panelId;

  @override
  State<PanelDetailScreen> createState() => _PanelDetailScreenState();
}

class _PanelDetailScreenState extends State<PanelDetailScreen> {
  bool _diagnosing = false;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final panels = context.watch<PanelsProvider>();
    final Panel? panel = panels.panelById(widget.panelId);

    if (panel == null) {
      return const Scaffold(
        body: Center(child: Text('Plate not found.')),
      );
    }

    final bool faulted = panel.isFaulted;
    final String photo = faulted
        ? AppAssets.imgDamaged
        : AppAssets
            .panelPhotos[panel.photoSeed % AppAssets.panelPhotos.length];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: p.background,
            title: Text(panel.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(photo, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.62),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 14,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PanelStatusChip(
                          label: faulted
                              ? panel.activeFault.label
                              : panel.status.label,
                          color: faulted
                              ? const Color(0xFFE5484D)
                              : const Color(0xFF2E9E5B),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${panel.model} • '
                          '${panel.ratedWatts.toStringAsFixed(0)}W • '
                          '${panel.location}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'IoT Device ${panel.deviceId} • installed '
                          '${AppFormatters.date(panel.installedOn)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (faulted) ...[
                  FaultBannerCard(panel: panel),
                  const SizedBox(height: 14),
                ],
                _HealthAndControl(panel: panel),
                const SizedBox(height: 16),
                const SectionHeader(title: 'Live Readings'),
                PanelReadingsGrid(panel: panel),
                const SizedBox(height: 16),
                const SectionHeader(
                    title: 'Power History',
                    subtitle: 'Live IoT readings, 4s cycle'),
                PanelPowerChart(panel: panel),
                const SizedBox(height: 16),
                const SectionHeader(
                  title: 'Diagnostics',
                  subtitle:
                      'Deep electrical test: link, voltage, temperature, output',
                ),
                _DiagnosticsSection(
                  panel: panel,
                  busy: _diagnosing,
                  onRun: _runDiagnostics,
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  title: 'Maintenance Log',
                  subtitle: 'Cleaning / repair / replacement history',
                ),
                ...panel.maintenanceLog.take(5).map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MaintenanceTile(record: m),
                      ),
                    ),
                const SizedBox(height: 6),
                AppGhostButton(
                  label: 'Remove This Plate',
                  icon: Icons.delete_outline,
                  danger: true,
                  onPressed: () => _confirmRemove(context, panel),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runDiagnostics() async {
    final panels = context.read<PanelsProvider>();
    final Panel? panel = panels.panelById(widget.panelId);
    if (panel == null) return;

    setState(() => _diagnosing = true);
    try {
      final report =
          await context.read<RunPanelDiagnostics>().execute(panel);
      await panels.saveDiagnosticReport(report);
      if (!mounted) return;
      setState(() => _diagnosing = false);
      showDiagnosticsSheet(context, report);
    } catch (e) {
      if (!mounted) return;
      setState(() => _diagnosing = false);
      AppSnackBar.error('Diagnostics failed: $e');
    }
  }

  Future<void> _confirmRemove(BuildContext context, Panel panel) async {
    final bool ok = await AppDialog.confirm(
      context,
      title: 'Remove ${panel.name}?',
      message:
          'The plate and its IoT device will be removed from monitoring. '
          'Historical readings will be lost.',
      confirmLabel: 'Remove',
      danger: true,
    );
    if (!ok || !mounted) return;
    await context.read<PanelsProvider>().remove(panel.id);
    if (!mounted) return;
    Navigator.maybePop(context);
  }
}

/// Health ring + power switch + maintenance toggle.
class _HealthAndControl extends StatelessWidget {
  const _HealthAndControl({required this.panel});

  final Panel panel;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return AppCard(
      child: Row(
        children: [
          HealthRing(score: panel.healthScore),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remote Control',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  panel.powerEnabled
                      ? 'Plate is ON and feeding the string.'
                      : 'Plate is switched OFF from the app.',
                  style: TextStyle(fontSize: 12, color: p.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Switch(
                      value: panel.powerEnabled,
                      onChanged: panel.status == PanelStatus.maintenance
                          ? null
                          : (v) => context
                              .read<PanelsProvider>()
                              .togglePower(panel.id),
                      activeTrackColor: const Color(0xFFF7A021),
                      activeColor: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      panel.powerEnabled ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: panel.powerEnabled
                            ? const Color(0xFF2E9E5B)
                            : p.textFaint,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => context
                          .read<PanelsProvider>()
                          .toggleMaintenance(panel.id),
                      icon: const Icon(Icons.engineering, size: 17),
                      label: Text(
                        panel.status == PanelStatus.maintenance
                            ? 'Exit Maintenance'
                            : 'Maintenance',
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Diagnostics block with run button + last report summary.
class _DiagnosticsSection extends StatelessWidget {
  const _DiagnosticsSection({
    required this.panel,
    required this.busy,
    required this.onRun,
  });

  final Panel panel;
  final bool busy;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final report = panel.lastDiagnostic;

    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: busy
                      ? 'Running 7 checks…'
                      : (report == null
                          ? 'Run Diagnostics'
                          : 'Re-run Diagnostics'),
                  icon: Icons.monitor_heart,
                  loading: busy,
                  onPressed: busy ? null : onRun,
                ),
              ),
            ],
          ),
          if (report != null && !busy) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  report.allPassed ? Icons.verified : Icons.warning_amber,
                  size: 18,
                  color: report.allPassed
                      ? const Color(0xFF2E9E5B)
                      : const Color(0xFFF5A524),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Last run ${AppFormatters.dateTime(report.completedAt)} • '
                    '${report.passedCount}/${report.totalCount} passed • health '
                    '${report.overallHealth}%',
                    style:
                        TextStyle(fontSize: 11.5, color: p.textSecondary),
                  ),
                ),
                GestureDetector(
                  onTap: () => showDiagnosticsSheet(context, report),
                  child: const Icon(Icons.open_in_new, size: 18),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}


