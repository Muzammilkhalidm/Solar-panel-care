import 'package:flutter/material.dart';

import '../theme/ui_helpers.dart';

/// Elevated rounded card with the theme-aware border + soft shadow.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
    this.gradient,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Gradient? gradient;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? p.card : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 18),
        border: Border.all(color: borderColor ?? p.cardBorder),
        boxShadow: p.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? 18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
