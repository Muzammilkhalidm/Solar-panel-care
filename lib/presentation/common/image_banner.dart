import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/ui_helpers.dart';

/// Reusable photo banner with dark gradient overlay — used by auth, about
/// and dashboard screens.
class ImageBanner extends StatelessWidget {
  const ImageBanner({
    super.key,
    required this.asset,
    required this.height,
    this.children,
    this.borderRadius,
    this.overlayOpacity,
  });

  final String asset;
  final double height;
  final List<Widget>? children;
  final double? borderRadius;
  final double? overlayOpacity;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity((overlayOpacity ?? 0.45) * 0.5),
                    Colors.black.withOpacity(overlayOpacity ?? 0.45),
                  ],
                ),
              ),
            ),
            if (children != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Small branded "Developed by Panel Care Team 7-H" credit row.
class DeveloperCredit extends StatelessWidget {
  const DeveloperCredit({
    super.key,
    this.compact = false,
    this.light = false,
  });

  final bool compact;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final Color color = light ? Colors.white70 : p.textFaint;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.solar_power, size: compact ? 13 : 15, color: color),
        const SizedBox(width: 6),
        Text(
          AppConstants.developerCredit,
          style: TextStyle(
            fontSize: compact ? 11 : 12.5,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
