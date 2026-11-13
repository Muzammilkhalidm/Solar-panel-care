import 'package:flutter/material.dart';

/// Palette contract implemented separately for light and dark themes.
abstract class AppPalette {
  // Surfaces
  Color get background;
  Color get surface;
  Color get surfaceAlt;
  Color get card;
  Color get cardBorder;

  // Text
  Color get textPrimary;
  Color get textSecondary;
  Color get textFaint;
  Color get textOnBrand;

  // Accents
  Color get brandPrimary;
  Color get brandSecondary;
  Color get heroOverlay;

  // Gradients
  LinearGradient get brandGradient;
  LinearGradient get cardGradient;
  LinearGradient get heroGradient;
  LinearGradient get statusGradient;

  // Charts & decorations
  Color get chartGrid;
  Color get chartAxisText;
  Color get shadowColor;
  List<BoxShadow> get cardShadow;

  // Soft tinted containers
  Color get successSoft;
  Color get warningSoft;
  Color get dangerSoft;
  Color get infoSoft;

  Brightness get brightness;
}
