import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/ui_helpers.dart';

/// System / Light / Dark selector cards.
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Row(
      children: [
        _Option(
          icon: Icons.brightness_auto,
          label: 'System',
          selected: theme.mode == ThemeMode.system,
          onTap: () => theme.setMode(ThemeMode.system),
        ),
        const SizedBox(width: 10),
        _Option(
          icon: Icons.light_mode,
          label: 'Light',
          selected: theme.mode == ThemeMode.light,
          onTap: () => theme.setMode(ThemeMode.light),
        ),
        const SizedBox(width: 10),
        _Option(
          icon: Icons.dark_mode,
          label: 'Dark',
          selected: theme.mode == ThemeMode.dark,
          onTap: () => theme.setMode(ThemeMode.dark),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFF7A021).withOpacity(0.16)
                : p.surfaceAlt,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFFF7A021)
                  : p.cardBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected
                    ? const Color(0xFFF7A021)
                    : p.textFaint,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight:
                      selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? const Color(0xFFF7A021)
                      : p.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
