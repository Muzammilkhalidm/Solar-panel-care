/// User-configurable system behaviour. Persisted as JSON via SettingsModel.
class SystemSettings {
  SystemSettings({
    this.notificationsEnabled = true,
    this.alarmSoundEnabled = true,
    this.vibrationEnabled = true,
    this.temperatureThreshold = 75.0,
    this.performanceThreshold = 55.0,
    this.autoShutdownOnFault = true,
    this.forceSunlight = true,
    this.autoScheduleEnabled = false,
  });

  final bool notificationsEnabled;
  final bool alarmSoundEnabled;
  final bool vibrationEnabled;

  /// °C — above this a plate raises an over-temperature alert.
  final double temperatureThreshold;

  /// % — below this (relative to expected output) a performance alert fires.
  final double performanceThreshold;

  /// Automatically cut power of a critically faulty plate.
  final bool autoShutdownOnFault;

  /// Demo mode: keep the sun "on" so the app always shows live production.
  final bool forceSunlight;

  /// Fake sunrise/sunset automation shown on the control screen.
  final bool autoScheduleEnabled;

  SystemSettings copyWith({
    bool? notificationsEnabled,
    bool? alarmSoundEnabled,
    bool? vibrationEnabled,
    double? temperatureThreshold,
    double? performanceThreshold,
    bool? autoShutdownOnFault,
    bool? forceSunlight,
    bool? autoScheduleEnabled,
  }) {
    return SystemSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      alarmSoundEnabled: alarmSoundEnabled ?? this.alarmSoundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      temperatureThreshold: temperatureThreshold ?? this.temperatureThreshold,
      performanceThreshold: performanceThreshold ?? this.performanceThreshold,
      autoShutdownOnFault: autoShutdownOnFault ?? this.autoShutdownOnFault,
      forceSunlight: forceSunlight ?? this.forceSunlight,
      autoScheduleEnabled: autoScheduleEnabled ?? this.autoScheduleEnabled,
    );
  }
}
