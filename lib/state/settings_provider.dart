import 'package:flutter/foundation.dart';

import '../data/repositories/settings_repository_impl.dart';
import '../domain/entities/system_settings.dart';
import '../services/alarm_player_service.dart';
import '../services/haptic_service.dart';
import '../services/notification_service.dart';

/// User-configurable behaviour (thresholds, alarm sound, demo sun...).
class SettingsProvider extends ChangeNotifier {
  SettingsProvider({
    required SettingsRepositoryImpl repository,
    required AlarmPlayerService alarmPlayer,
    required HapticService haptics,
  })  : _repository = repository,
        _alarmPlayer = alarmPlayer,
        _haptics = haptics;

  final SettingsRepositoryImpl _repository;
  final AlarmPlayerService _alarmPlayer;
  final HapticService _haptics;

  SystemSettings settings = SystemSettings();
  bool loading = true;

  Future<void> load() async {
    settings = await _repository.getSettings();
    _applySideEffects();
    loading = false;
    notifyListeners();
  }

  Future<void> update(SystemSettings next) async {
    settings = next;
    await _repository.saveSettings(next);
    _applySideEffects();
    notifyListeners();
  }

  Future<void> setNotifications(bool v) =>
      update(settings.copyWith(notificationsEnabled: v));

  Future<void> setAlarmSound(bool v) =>
      update(settings.copyWith(alarmSoundEnabled: v));

  Future<void> setVibration(bool v) async {
    if (v) await _haptics.lightTick();
    await update(settings.copyWith(vibrationEnabled: v));
  }

  Future<void> setAutoShutdown(bool v) =>
      update(settings.copyWith(autoShutdownOnFault: v));

  Future<void> setForceSunlight(bool v) =>
      update(settings.copyWith(forceSunlight: v));

  Future<void> setAutoSchedule(bool v) =>
      update(settings.copyWith(autoScheduleEnabled: v));

  Future<void> setTemperatureThreshold(double v) =>
      update(settings.copyWith(temperatureThreshold: v));

  Future<void> setPerformanceThreshold(double v) =>
      update(settings.copyWith(performanceThreshold: v));

  Future<void> testAlarm() => _alarmPlayer.testAlarm();

  Future<void> reset() async {
    await _repository.reset();
    settings = await _repository.getSettings();
    _applySideEffects();
    notifyListeners();
  }

  void _applySideEffects() {
    _alarmPlayer.enabled = settings.alarmSoundEnabled;
    NotificationService.instance.enabled = settings.notificationsEnabled;
    // Vibration is checked per call inside HapticService.
  }
}
