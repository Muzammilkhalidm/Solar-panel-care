import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/pulse_dot.dart';
import '../../../state/iot_connection_provider.dart';
import '../../../state/panels_provider.dart';
import '../../../state/stats_provider.dart';

/// Premium dark hero card: solar photo, system output, master switch and
/// eco insight chips — the signature "Voltix" look.
class SystemStatusCard extends StatelessWidget {
  const SystemStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final panels = context.watch<PanelsProvider>();
    final stats = context.watch<StatsProvider>().stats;
    final link = context.watch<IotConnectionProvider>();

    final Color linkColor = link.isConnected
        ? const Color(0xFF7CE495)
        : (link.state == IotLinkState.connecting
            ? const Color(0xFFFFC65C)
            : const Color(0xFFB0BEC5));

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E2A20), Color(0xFF1D1B17)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40241C08),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Photo header with LIVE badge + hub chip ----
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/rooftop_panels.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.10),
                        const Color(0xFF1D1B17).withOpacity(0.92),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 14,
                  child: _GlassChip(
                    icon: Icons.link,
                    label: link.stateLabel,
                    color: linkColor,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 14,
                  child: Row(
                    children: [
                      PulseDot(color: linkColor, size: 8),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFFC65C),
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'System Output',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.72),
                              ),
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${panels.totalPowerNow.toStringAsFixed(0)} W',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.2,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            Text(
                              '${panels.producingCount} of ${panels.total} plates producing now',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            'MASTER',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withOpacity(0.65),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Switch(
                            value: panels.systemOn,
                            onChanged: (v) =>
                                context.read<PanelsProvider>().setSystemPower(v),
                            activeTrackColor: const Color(0xFFFF7E2D),
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // ---- Eco chips (CO2 / trees / savings) ----
                  Row(
                    children: [
                      _EcoChip(
                        icon: Icons.co2_outlined,
                        value: stats == null
                            ? '—'
                            : '${stats.co2SavedKg.toStringAsFixed(2)} kg',
                        label: 'CO₂ saved',
                      ),
                      const SizedBox(width: 8),
                      _EcoChip(
                        icon: Icons.park_outlined,
                        value: stats == null
                            ? '—'
                            : '${stats.treesEquivalent}',
                        label: 'trees eq.',
                      ),
                      const SizedBox(width: 8),
                      _EcoChip(
                        icon: Icons.savings_outlined,
                        value: stats == null
                            ? '—'
                            : 'Rs ${stats.moneySavedPkr.toStringAsFixed(0)}',
                        label: 'saved today',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // ---- Fleet health mini-stats ----
                  Row(
                    children: [
                      _MiniStat(
                          icon: Icons.check_circle,
                          color: const Color(0xFF7CE495),
                          label: 'Healthy',
                          value:
                              '${panels.total - panels.faultedCount - panels.offlineCount - panels.poweredOffCount}'),
                      const SizedBox(width: 8),
                      _MiniStat(
                          icon: Icons.report_problem,
                          color: const Color(0xFFFF8A80),
                          label: 'Faulty',
                          value: '${panels.faultedCount}'),
                      const SizedBox(width: 8),
                      _MiniStat(
                          icon: Icons.wifi_off,
                          color: const Color(0xFFB0BEC5),
                          label: 'Offline',
                          value: '${panels.offlineCount}'),
                      const SizedBox(width: 8),
                      _MiniStat(
                          icon: Icons.power_off,
                          color: const Color(0xFF90CAF9),
                          label: 'Off',
                          value: '${panels.poweredOffCount}'),
                    ],
                  ),
                  if (!panels.systemOn) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7E2D).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 15, color: Color(0xFFFFC65C)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'System is powered OFF — turn the master switch ON.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFFFFE3B3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EcoChip extends StatelessWidget {
  const _EcoChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 15, color: const Color(0xFFFFC65C)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.62),
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
