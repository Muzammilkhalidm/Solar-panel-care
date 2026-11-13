import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../state/panels_provider.dart';

/// Big hero card with the master system switch.
class MasterSwitchCard extends StatelessWidget {
  const MasterSwitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final panels = context.watch<PanelsProvider>();
    final bool on = panels.systemOn;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: on
            ? const LinearGradient(
                colors: [Color(0xFF2E7DD1), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [p.surfaceAlt, p.surfaceAlt],
              ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: p.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOLAR SYSTEM',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: on
                        ? Colors.white.withOpacity(0.8)
                        : p.textFaint,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  on ? 'Producing Now' : 'System Off',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: on ? Colors.white : p.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  on
                      ? '${AppFormatters.watts(panels.totalPowerNow)} • '
                          '${panels.producingCount}/${panels.total} plates'
                      : 'Turn on to resume production',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: on
                        ? Colors.white.withOpacity(0.85)
                        : p.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            children: [
              Transform.scale(
                scale: 1.25,
                child: Switch(
                  value: on,
                  onChanged: (v) =>
                      context.read<PanelsProvider>().setSystemPower(v),
                  activeTrackColor: const Color(0xFFF7A021),
                  activeColor: Colors.white,
                ),
              ),
              Text(
                on ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: on ? const Color(0xFFF7A021) : p.textFaint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
