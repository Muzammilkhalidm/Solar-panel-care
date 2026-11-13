/// One live reading captured from a panel's IoT device.
class PanelReading {
  PanelReading({
    required this.timestamp,
    required this.voltage,
    required this.current,
    required this.power,
    required this.temperature,
    required this.irradiance,
    required this.efficiency,
  });

  final DateTime timestamp;
  final double voltage; // V
  final double current; // A
  final double power; // W
  final double temperature; // °C
  final double irradiance; // W/m²
  final double efficiency; // %

  factory PanelReading.zero() => PanelReading(
        timestamp: DateTime.now(),
        voltage: 0,
        current: 0,
        power: 0,
        temperature: 25,
        irradiance: 0,
        efficiency: 0,
      );

  PanelReading copyWith({
    DateTime? timestamp,
    double? voltage,
    double? current,
    double? power,
    double? temperature,
    double? irradiance,
    double? efficiency,
  }) {
    return PanelReading(
      timestamp: timestamp ?? this.timestamp,
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      power: power ?? this.power,
      temperature: temperature ?? this.temperature,
      irradiance: irradiance ?? this.irradiance,
      efficiency: efficiency ?? this.efficiency,
    );
  }
}

/// Aggregated system-wide snapshot (all panels together).
typedef SystemSnapshot = PanelReading;
