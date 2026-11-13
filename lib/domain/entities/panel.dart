/// Main solar plate entity. Live values are mutated by the IoT engine and
/// refreshed in the UI through providers.
import 'diagnostic_report.dart';
import 'maintenance_record.dart';
import 'panel_fault.dart';
import 'panel_reading.dart';

enum PanelStatus { online, offline, fault, maintenance, off }

extension PanelStatusX on PanelStatus {
  String get label {
    switch (this) {
      case PanelStatus.online:
        return 'Online';
      case PanelStatus.offline:
        return 'Offline';
      case PanelStatus.fault:
        return 'Fault';
      case PanelStatus.maintenance:
        return 'Maintenance';
      case PanelStatus.off:
        return 'Powered Off';
    }
  }
}

class Panel {
  Panel({
    required this.id,
    required this.name,
    required this.model,
    required this.ratedWatts,
    required this.deviceId,
    required this.location,
    required this.installedOn,
    required this.lastMaintenance,
    this.status = PanelStatus.online,
    this.activeFault = PanelFaultType.none,
    this.powerEnabled = true,
    this.voltage = 0,
    this.current = 0,
    this.power = 0,
    this.temperature = 25,
    this.irradiance = 0,
    this.efficiency = 0,
    this.energyTodayKwh = 0,
    this.lifetimeEnergyKwh = 0,
    this.healthScore = 100,
    List<PanelReading>? history,
    List<MaintenanceRecord>? maintenanceLog,
    this.lastDiagnostic,
  })  : history = history ?? [],
        maintenanceLog = maintenanceLog ?? [];

  final String id;
  final String name;
  final String model;
  final double ratedWatts;
  final String deviceId;
  final String location;
  final DateTime installedOn;
  DateTime lastMaintenance;

  PanelStatus status;
  PanelFaultType activeFault;
  bool powerEnabled;

  // Live readings
  double voltage;
  double current;
  double power;
  double temperature;
  double irradiance;
  double efficiency;

  // Energy accounting
  double energyTodayKwh;
  double lifetimeEnergyKwh;

  // Health 0..100
  int healthScore;

  final List<PanelReading> history;
  final List<MaintenanceRecord> maintenanceLog;
  DiagnosticReport? lastDiagnostic;

  bool get isProducing => powerEnabled && power > 5;

  bool get isFaulted => activeFault.isActive || status == PanelStatus.fault;

  bool get isControllable =>
      status != PanelStatus.maintenance;

  /// Plate photo index helper for card thumbnails.
  int get photoSeed => id.hashCode.abs();
}
