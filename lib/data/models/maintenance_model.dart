import '../../core/utils/extensions.dart';
import '../../domain/entities/maintenance_record.dart';

/// JSON-mappable variant of [MaintenanceRecord].
class MaintenanceModel extends MaintenanceRecord {
  MaintenanceModel({
    required super.id,
    required super.panelId,
    required super.panelName,
    required super.type,
    required super.status,
    required super.note,
    required super.technician,
    required super.cost,
    required super.date,
  });

  factory MaintenanceModel.fromEntity(MaintenanceRecord m) =>
      MaintenanceModel(
        id: m.id,
        panelId: m.panelId,
        panelName: m.panelName,
        type: m.type,
        status: m.status,
        note: m.note,
        technician: m.technician,
        cost: m.cost,
        date: m.date,
      );

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'] as String,
      panelId: json['panelId'] as String,
      panelName: json['panelName'] as String? ?? '—',
      type: enumByName(MaintenanceType.values, json['type'] as String?,
          MaintenanceType.inspection),
      status: enumByName(MaintenanceStatus.values,
          json['status'] as String?, MaintenanceStatus.completed),
      note: json['note'] as String? ?? '',
      technician: json['technician'] as String? ?? '—',
      cost: (json['cost'] as num? ?? 0).toDouble(),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'panelId': panelId,
        'panelName': panelName,
        'type': type.name,
        'status': status.name,
        'note': note,
        'technician': technician,
        'cost': cost,
        'date': date.toIso8601String(),
      };

  static List<MaintenanceRecord> listToEntity(List<dynamic> list) => list
      .map((e) =>
          MaintenanceModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}
