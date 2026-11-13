import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';

/// Premium action bar: glowing gradient "Register Plate" button plus the
/// demo/maintenance actions.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    required this.onSimulateFault,
    required this.onShutdownAll,
    required this.onAddPanel,
    required this.onAnalytics,
  });

  final VoidCallback onSimulateFault;
  final VoidCallback onShutdownAll;
  final VoidCallback onAddPanel;
  final VoidCallback onAnalytics;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        // ---- Primary: Register Plate (gradient pill) ----
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAddPanel,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC65C), Color(0xFFF7A021), Color(0xFFFF7E2D)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40FF7E2D),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline,
                      size: 21, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Register New Plate',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _Action(
              icon: Icons.bug_report,
              label: 'Simulate\nDamage',
              color: const Color(0xFFE5484D),
              onTap: onSimulateFault,
            ),
            const SizedBox(width: 10),
            _Action(
              icon: Icons.power_settings_new,
              label: 'Shutdown\nAll',
              color: const Color(0xFFE85D04),
              onTap: onShutdownAll,
            ),
            const SizedBox(width: 10),
            _Action(
              icon: Icons.insights,
              label: 'Analytics\n& Savings',
              color: const Color(0xFF3D9A50),
              onTap: onAnalytics,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Simulate Damage demo ke liye hai — ek healthy plate kharab hoti hai '
          'aur poora alert + alarm flow chalta hai.',
          style: TextStyle(fontSize: 10.5, color: p.textFaint),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: p.cardBorder),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: p.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
