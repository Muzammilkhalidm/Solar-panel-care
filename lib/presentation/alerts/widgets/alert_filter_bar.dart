import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';

/// Row of filter chips (All / Active / Critical / Resolved).
class AlertFilterBar extends StatelessWidget {
  const AlertFilterBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final bool selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFF7A021).withOpacity(0.22)
                    : p.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFF7A021)
                      : p.cardBorder,
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFFF7A021)
                      : p.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
