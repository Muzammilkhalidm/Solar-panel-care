import 'package:flutter/material.dart';

export 'app_palette.dart';

import 'app_palette.dart';
import 'dark_palette.dart';
import 'light_palette.dart';

/// Returns the right palette for the current theme brightness.
AppPalette paletteOf(Brightness brightness) =>
    brightness == Brightness.dark ? const DarkPalette() : const LightPalette();

extension PaletteContextX on BuildContext {
  /// Current light/dark palette.
  AppPalette get palette => paletteOf(Theme.of(this).brightness);

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
