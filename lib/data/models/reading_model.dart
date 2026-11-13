import '../../domain/entities/panel_reading.dart';

/// JSON-mappable variant of [PanelReading].
class ReadingModel extends PanelReading {
  ReadingModel({
    required super.timestamp,
    required super.voltage,
    required super.current,
    required super.power,
    required super.temperature,
    required super.irradiance,
    required super.efficiency,
  });

  factory ReadingModel.fromEntity(PanelReading r) => ReadingModel(
        timestamp: r.timestamp,
        voltage: r.voltage,
        current: r.current,
        power: r.power,
        temperature: r.temperature,
        irradiance: r.irradiance,
        efficiency: r.efficiency,
      );

  factory ReadingModel.fromJson(Map<String, dynamic> json) {
    return ReadingModel(
      timestamp:
          DateTime.tryParse(json['ts'] as String? ?? '') ?? DateTime.now(),
      voltage: (json['v'] as num? ?? 0).toDouble(),
      current: (json['i'] as num? ?? 0).toDouble(),
      power: (json['p'] as num? ?? 0).toDouble(),
      temperature: (json['t'] as num? ?? 25).toDouble(),
      irradiance: (json['w'] as num? ?? 0).toDouble(),
      efficiency: (json['e'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'ts': timestamp.toIso8601String(),
        'v': voltage,
        'i': current,
        'p': power,
        't': temperature,
        'w': irradiance,
        'e': efficiency,
      };

  static List<ReadingModel> listFromEntity(List<PanelReading> list) =>
      list.map(ReadingModel.fromEntity).toList();

  static List<PanelReading> listToEntity(List<dynamic> list) => list
      .map((e) =>
          ReadingModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}
