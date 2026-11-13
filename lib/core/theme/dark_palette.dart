import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';

/// Premium warm-charcoal dark theme — soft "night solar" surfaces with
/// glowing amber accents.
class DarkPalette implements AppPalette {
  const DarkPalette();

  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get background => AppColors.midnight;

  @override
  Color get surface => const Color(0xFF1B1915);

  @override
  Color get surfaceAlt => const Color(0xFF262319);

  @override
  Color get card => const Color(0xFF201D17);

  @override
  Color get cardBorder => const Color(0xFF35301F);

  @override
  Color get textPrimary => const Color(0xFFF4EFE3);

  @override
  Color get textSecondary => const Color(0xFFBDB4A0);

  @override
  Color get textFaint => const Color(0xFF847C68);

  @override
  Color get textOnBrand => const Color(0xFF171510);

  @override
  Color get brandPrimary => AppColors.sunAmber;

  @override
  Color get brandSecondary => AppColors.sunGlow;

  @override
  Color get heroOverlay => Colors.black.withOpacity(0.55);

  @override
  LinearGradient get brandGradient => AppColors.energyGradient;

  @override
  LinearGradient get cardGradient => const LinearGradient(
        colors: [Color(0xFF262219), Color(0xFF1B1915)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  @override
  LinearGradient get heroGradient => const LinearGradient(
        colors: [Color(0xFF2E2A20), AppColors.charcoal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get statusGradient => LinearGradient(
        colors: [AppColors.success.withOpacity(0.20), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  @override
  Color get chartGrid => const Color(0xFF35301F);

  @override
  Color get chartAxisText => const Color(0xFF9C937D);

  @override
  Color get shadowColor => const Color(0x66000000);

  @override
  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ];

  @override
  Color get successSoft => const Color(0xFF1C2E1D);

  @override
  Color get warningSoft => const Color(0xFF332914);

  @override
  Color get dangerSoft => const Color(0xFF3A1719);

  @override
  Color get infoSoft => const Color(0xFF182638);
}
