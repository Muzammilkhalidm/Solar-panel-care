import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/ui_helpers.dart';

/// Primary amber button with optional icon and loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.expanded = true,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool expanded;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final Widget child = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor:
                  AlwaysStoppedAnimation<Color>(foregroundColor ?? p.textOnBrand),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foregroundColor ?? p.textOnBrand),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: foregroundColor ?? p.textOnBrand,
                ),
              ),
            ],
          );

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: foregroundColor ?? p.textOnBrand,
        minimumSize: Size(expanded ? double.infinity : 0, height ?? AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        elevation: 0,
      ),
      child: child,
    );
  }
}

/// Ghost / outlined secondary button.
class AppGhostButton extends StatelessWidget {
  const AppGhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.danger = false,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool danger;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final Color color = danger ? AppColorsStatus.danger : p.textPrimary;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(expanded ? double.infinity : 0, AppDimensions.buttonHeight),
        side: BorderSide(color: danger ? AppColorsStatus.danger : p.cardBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        foregroundColor: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 19, color: color), const SizedBox(width: 8)],
          Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

/// Re-export of semantic status colors for convenience in UI files.
class AppColorsStatus {
  static const Color danger = Color(0xFFE5484D);
  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFF5A524);
  static const Color info = Color(0xFF3B82F6);
}
