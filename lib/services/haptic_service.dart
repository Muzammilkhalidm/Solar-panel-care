import 'package:vibration/vibration.dart';

import '../core/utils/logger.dart';

/// Haptic feedback patterns for alerts (critical faults get a heavy triple
/// pulse). Safely no-ops on devices/platforms without a vibrator.
class HapticService {
  HapticService();

  Future<bool> get _hasVibrator async {
    try {
      return await Vibration.hasVibrator() == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> alertPattern({bool critical = false}) async {
    try {
      if (!await _hasVibrator) return;
      if (critical) {
        await Vibration.vibrate(
          pattern: [0, 550, 180, 550, 180, 550],
          intensities: [0, 255, 0, 255, 0, 255],
        );
      } else {
        await Vibration.vibrate(pattern: [0, 260], intensities: [0, 128]);
      }
    } catch (e) {
      AppLogger.e('Haptics', 'Vibration failed', e);
    }
  }

  Future<void> lightTick() async {
    try {
      if (!await _hasVibrator) return;
      await Vibration.vibrate(duration: 25);
    } catch (_) {}
  }
}
