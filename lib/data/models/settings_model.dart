import '../../domain/entities/system_settings.dart';

/// JSON-mappable variant of [SystemSettings].
class SettingsModel extends SystemSettings {
  SettingsModel({
    super.notificationsEnabled,
    super.alarmSoundEnabled,
    super.vibrationEnabled,
    super.temperatureThreshold,
    super.performanceThreshold,
    super.autoShutdownOnFault,
    super.forceSunlight,
    super.autoScheduleEnabled,
  });

  factory SettingsModel.fromEntity(SystemSettings s) => SettingsModel(
        notificationsEnabled: s.notificationsEnabled,
        alarmSoundEnabled: s.alarmSoundEnabled,
        vibrationEnabled: s.vibrationEnabled,
        temperatureThreshold: s.temperatureThreshold,
        performanceThreshold: s.performanceThreshold,
        autoShutdownOnFault: s.autoShutdownOnFault,
        forceSunlight: s.forceSunlight,
        autoScheduleEnabled: s.autoScheduleEnabled,
      );

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      alarmSoundEnabled: json['alarmSoundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      temperatureThreshold:
          (json['temperatureThreshold'] as num? ?? 75).toDouble(),
      performanceThreshold:
          (json['performanceThreshold'] as num? ?? 55).toDouble(),
      autoShutdownOnFault: json['autoShutdownOnFault'] as bool? ?? true,
      forceSunlight: json['forceSunlight'] as bool? ?? true,
      autoScheduleEnabled: json['autoScheduleEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationsEnabled': notificationsEnabled,
        'alarmSoundEnabled': alarmSoundEnabled,
        'vibrationEnabled': vibrationEnabled,
        'temperatureThreshold': temperatureThreshold,
        'performanceThreshold': performanceThreshold,
        'autoShutdownOnFault': autoShutdownOnFault,
        'forceSunlight': forceSunlight,
        'autoScheduleEnabled': autoScheduleEnabled,
      };
}
