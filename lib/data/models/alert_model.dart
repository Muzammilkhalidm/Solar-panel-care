import '../../core/utils/extensions.dart';
import '../../domain/entities/alert.dart';
import '../../domain/entities/panel_fault.dart';

/// JSON-mappable variant of [Alert].
class AlertModel extends Alert {
  AlertModel({
    required super.id,
    required super.panelId,
    required super.panelName,
    required super.title,
    required super.message,
    required super.severity,
    required super.type,
    required super.createdAt,
    super.faultType,
    super.resolved,
    super.resolvedAt,
    super.snapshot,
  });

  factory AlertModel.fromEntity(Alert a) => AlertModel(
        id: a.id,
        panelId: a.panelId,
        panelName: a.panelName,
        title: a.title,
        message: a.message,
        severity: a.severity,
        type: a.type,
        createdAt: a.createdAt,
        faultType: a.faultType,
        resolved: a.resolved,
        resolvedAt: a.resolvedAt,
        snapshot: a.snapshot,
      );

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      panelId: json['panelId'] as String,
      panelName: json['panelName'] as String? ?? '—',
      title: json['title'] as String? ?? 'Alert',
      message: json['message'] as String? ?? '',
      severity: enumByName(
          AlertSeverity.values, json['severity'] as String?, AlertSeverity.low),
      type: enumByName(
          AlertType.values, json['type'] as String?, AlertType.system),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
              DateTime.now(),
      faultType: enumByName(PanelFaultType.values,
          json['faultType'] as String?, PanelFaultType.none),
      resolved: json['resolved'] as bool? ?? false,
      resolvedAt: DateTime.tryParse(json['resolvedAt'] as String? ?? ''),
      snapshot:
          Map<String, dynamic>.from(json['snapshot'] as Map? ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'panelId': panelId,
        'panelName': panelName,
        'title': title,
        'message': message,
        'severity': severity.name,
        'type': type.name,
        'createdAt': createdAt.toIso8601String(),
        'faultType': faultType.name,
        'resolved': resolved,
        'resolvedAt': resolvedAt?.toIso8601String(),
        'snapshot': snapshot,
      };

  static List<Alert> listToEntity(List<dynamic> list) => list
      .map((e) => AlertModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();

  static List<Map<String, dynamic>> listFromEntity(List<Alert> list) =>
      list.map((a) => AlertModel.fromEntity(a).toJson()).toList();
}
