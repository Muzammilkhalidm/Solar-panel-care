import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';

/// Premium warm-cream light theme — soft beige canvas, white cards,
/// charcoal hero panels and glowing amber accents (Voltix style).
class LightPalette implements AppPalette {
  const LightPalette();

  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get background => AppColors.cream;

  @override
  Color get surface => const Color(0xFFFDFCF8);

  @override
  Color get surfaceAlt => const Color(0xFFF3EFE4);

  @override
  Color get card => Colors.white;

  @override
  Color get cardBorder => const Color(0xFFE4DDCC);

  @override
  Color get textPrimary => const Color(0xFF211E17);

  @override
  Color get textSecondary => const Color(0xFF6E6759);

  @override
  Color get textFaint => const Color(0xFFA69E8C);

  @override
  Color get textOnBrand => Colors.white;

  @override
  Color get brandPrimary => AppColors.sunAmber;

  @override
  Color get brandSecondary => AppColors.deepOrange;

  @override
  Color get heroOverlay => Colors.black.withOpacity(0.45);

  @override
  LinearGradient get brandGradient => AppColors.energyGradient;

  @override
  LinearGradient get cardGradient => const LinearGradient(
        colors: [Colors.white, Color(0xFFFCFAF4)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  @override
  LinearGradient get heroGradient => const LinearGradient(
        colors: [AppColors.charcoalSoft, AppColors.charcoal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get statusGradient => LinearGradient(
        colors: [AppColors.success.withOpacity(0.16), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  @override
  Color get chartGrid => const Color(0xFFE9E2D2);

  @override
  Color get chartAxisText => const Color(0xFF8D8571);

  @override
  Color get shadowColor => const Color(0x24201C12);

  @override
  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0x1F5C4E1E),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ];

  @override
  Color get successSoft => const Color(0xFFE3F2E4);

  @override
  Color get warningSoft => const Color(0xFFFFF3D9);

  @override
  Color get dangerSoft => const Color(0xFFFBE7E7);

  @override
  Color get infoSoft => const Color(0xFFE6EFFB);
}
