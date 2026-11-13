import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';

/// Big red emergency stop block. The screen supplies the confirm dialog.
class EmergencyShutdownButton extends StatelessWidget {
  const EmergencyShutdownButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: p.dangerSoft,
          borderRadius: BorderRadius.circular(18),
          border:
              Border.all(color: const Color(0xFFE5484D).withOpacity(0.55)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFE5484D).withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.dangerous,
                  color: Color(0xFFE5484D), size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emergency Shutdown',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE5484D),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Fire, storm ya maintenance ke liye poora system turant OFF.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: p.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE5484D)),
          ],
        ),
      ),
    );
  }
}
