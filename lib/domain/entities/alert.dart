import 'panel_fault.dart';

enum AlertSeverity { info, low, medium, high, critical }

enum AlertType { fault, performance, temperature, connection, maintenanceReminder, system }

extension AlertSeverityX on AlertSeverity {
  String get label {
    switch (this) {
      case AlertSeverity.info:
        return 'Info';
      case AlertSeverity.low:
        return 'Low';
      case AlertSeverity.medium:
        return 'Medium';
      case AlertSeverity.high:
        return 'High';
      case AlertSeverity.critical:
        return 'CRITICAL';
    }
  }
}

extension AlertTypeX on AlertType {
  String get label {
    switch (this) {
      case AlertType.fault:
        return 'Plate Fault';
      case AlertType.performance:
        return 'Low Performance';
      case AlertType.temperature:
        return 'High Temperature';
      case AlertType.connection:
        return 'Connection';
      case AlertType.maintenanceReminder:
        return 'Maintenance';
      case AlertType.system:
        return 'System';
    }
  }
}

/// An alert created when a solar plate needs attention.
class Alert {
  Alert({
    required this.id,
    required this.panelId,
    required this.panelName,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    required this.createdAt,
    this.faultType = PanelFaultType.none,
    this.resolved = false,
    this.resolvedAt,
    Map<String, dynamic>? snapshot,
  }) : snapshot = snapshot ?? {};

  final String id;
  final String panelId;
  final String panelName;
  final String title;
  final String message;
  final AlertSeverity severity;
  final AlertType type;
  final DateTime createdAt;
  final PanelFaultType faultType;
  bool resolved;
  DateTime? resolvedAt;

  /// Live readings captured at the moment the alert fired.
  final Map<String, dynamic> snapshot;

  bool get isActive => !resolved;
}
