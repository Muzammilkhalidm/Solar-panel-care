import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../core/constants/app_assets.dart';
import '../core/utils/logger.dart';

/// Plays the bundled emergency alarm when a plate is damaged.
/// Looping until the user stops it from the alert banner.
class AlarmPlayerService {
  AlarmPlayerService();

  final AudioPlayer _player = AudioPlayer();
  bool _enabled = true;
  bool _playing = false;
  Timer? _testTimer;

  bool get isPlaying => _playing;

  set enabled(bool value) {
    _enabled = value;
    if (!value) stopAlarm();
  }

  Future<void> startAlarm() async {
    if (!_enabled || _playing) return;
    try {
      _playing = true;
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource(AppAssets.alarmAssetSource));
      AppLogger.i('Alarm', 'Emergency alarm started');
    } catch (e) {
      _playing = false;
      AppLogger.e('Alarm', 'Failed to play alarm', e);
    }
  }

  Future<void> stopAlarm() async {
    if (!_playing) return;
    _playing = false;
    try {
      await _player.stop();
      AppLogger.i('Alarm', 'Emergency alarm stopped');
    } catch (e) {
      AppLogger.e('Alarm', 'Failed to stop alarm', e);
    }
  }

  /// 3-second test ring used from Settings so the user can preview it.
  Future<void> testAlarm() async {
    final bool wasEnabled = _enabled;
    _enabled = true;
    await startAlarm();
    _testTimer?.cancel();
    _testTimer = Timer(const Duration(seconds: 3), () {
      stopAlarm();
      _enabled = wasEnabled;
    });
  }

  void dispose() {
    _testTimer?.cancel();
    _player.dispose();
  }
}
