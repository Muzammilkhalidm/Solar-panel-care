import '../../core/utils/extensions.dart';
import '../../domain/entities/panel.dart';
import '../../domain/entities/panel_fault.dart';
import 'diagnostic_report_model.dart';
import 'maintenance_model.dart';
import 'reading_model.dart';

/// JSON-mappable variant of [Panel].
class PanelModel extends Panel {
  PanelModel({
    required super.id,
    required super.name,
    required super.model,
    required super.ratedWatts,
    required super.deviceId,
    required super.location,
    required super.installedOn,
    required super.lastMaintenance,
    super.status,
    super.activeFault,
    super.powerEnabled,
    super.voltage,
    super.current,
    super.power,
    super.temperature,
    super.irradiance,
    super.efficiency,
    super.energyTodayKwh,
    super.lifetimeEnergyKwh,
    super.healthScore,
    super.history,
    super.maintenanceLog,
    super.lastDiagnostic,
  });

  factory PanelModel.fromEntity(Panel p) => PanelModel(
        id: p.id,
        name: p.name,
        model: p.model,
        ratedWatts: p.ratedWatts,
        deviceId: p.deviceId,
        location: p.location,
        installedOn: p.installedOn,
        lastMaintenance: p.lastMaintenance,
        status: p.status,
        activeFault: p.activeFault,
        powerEnabled: p.powerEnabled,
        voltage: p.voltage,
        current: p.current,
        power: p.power,
        temperature: p.temperature,
        irradiance: p.irradiance,
        efficiency: p.efficiency,
        energyTodayKwh: p.energyTodayKwh,
        lifetimeEnergyKwh: p.lifetimeEnergyKwh,
        healthScore: p.healthScore,
        history: p.history,
        maintenanceLog: p.maintenanceLog,
        lastDiagnostic: p.lastDiagnostic,
      );

  factory PanelModel.fromJson(Map<String, dynamic> json) {
    return PanelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String? ?? 'Unknown Model',
      ratedWatts: (json['ratedWatts'] as num? ?? 500).toDouble(),
      deviceId: json['deviceId'] as String? ?? 'IOT-UNKNOWN',
      location: json['location'] as String? ?? '—',
      installedOn:
          DateTime.tryParse(json['installedOn'] as String? ?? '') ??
              DateTime.now(),
      lastMaintenance:
          DateTime.tryParse(json['lastMaintenance'] as String? ?? '') ??
              DateTime.now(),
      status: enumByName(
          PanelStatus.values, json['status'] as String?, PanelStatus.offline),
      activeFault: enumByName(PanelFaultType.values,
          json['activeFault'] as String?, PanelFaultType.none),
      powerEnabled: json['powerEnabled'] as bool? ?? true,
      voltage: (json['voltage'] as num? ?? 0).toDouble(),
      current: (json['current'] as num? ?? 0).toDouble(),
      power: (json['power'] as num? ?? 0).toDouble(),
      temperature: (json['temperature'] as num? ?? 25).toDouble(),
      irradiance: (json['irradiance'] as num? ?? 0).toDouble(),
      efficiency: (json['efficiency'] as num? ?? 0).toDouble(),
      energyTodayKwh: (json['energyTodayKwh'] as num? ?? 0).toDouble(),
      lifetimeEnergyKwh: (json['lifetimeEnergyKwh'] as num? ?? 0).toDouble(),
      healthScore: json['healthScore'] as int? ?? 100,
      history: ReadingModel.listToEntity(json['history'] as List? ?? []),
      maintenanceLog: MaintenanceModel.listToEntity(
          json['maintenanceLog'] as List? ?? []),
      lastDiagnostic: json['lastDiagnostic'] == null
          ? null
          : DiagnosticReportModel.fromJson(
              Map<String, dynamic>.from(json['lastDiagnostic'] as Map)),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'model': model,
        'ratedWatts': ratedWatts,
        'deviceId': deviceId,
        'location': location,
        'installedOn': installedOn.toIso8601String(),
        'lastMaintenance': lastMaintenance.toIso8601String(),
        'status': status.name,
        'activeFault': activeFault.name,
        'powerEnabled': powerEnabled,
        'voltage': voltage,
        'current': current,
        'power': power,
        'temperature': temperature,
        'irradiance': irradiance,
        'efficiency': efficiency,
        'energyTodayKwh': energyTodayKwh,
        'lifetimeEnergyKwh': lifetimeEnergyKwh,
        'healthScore': healthScore,
        'history': history.map((r) => ReadingModel.fromEntity(r).toJson()).toList(),
        'maintenanceLog': maintenanceLog
            .map((m) => MaintenanceModel.fromEntity(m).toJson())
            .toList(),
        'lastDiagnostic': lastDiagnostic == null
            ? null
            : DiagnosticReportModel.fromEntity(lastDiagnostic!).toJson(),
      };

  static List<Panel> listToEntity(List<dynamic> list) => list
      .map((e) => PanelModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();

  static List<Map<String, dynamic>> listFromEntity(List<Panel> list) =>
      list.map((p) => PanelModel.fromEntity(p).toJson()).toList();
}
