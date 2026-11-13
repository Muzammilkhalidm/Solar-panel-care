import 'package:flutter/material.dart' show IconData, Icons;

enum MaintenanceType { inspection, cleaning, repair, replacement, diagnostic }

enum MaintenanceStatus { scheduled, inProgress, completed }

extension MaintenanceTypeX on MaintenanceType {
  String get label {
    switch (this) {
      case MaintenanceType.inspection:
        return 'Inspection';
      case MaintenanceType.cleaning:
        return 'Cleaning';
      case MaintenanceType.repair:
        return 'Repair';
      case MaintenanceType.replacement:
        return 'Replacement';
      case MaintenanceType.diagnostic:
        return 'Diagnostics';
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenanceType.inspection:
        return Icons.search;
      case MaintenanceType.cleaning:
        return Icons.cleaning_services;
      case MaintenanceType.repair:
        return Icons.build;
      case MaintenanceType.replacement:
        return Icons.swap_horiz;
      case MaintenanceType.diagnostic:
        return Icons.monitor_heart;
    }
  }
}

extension MaintenanceStatusX on MaintenanceStatus {
  String get label {
    switch (this) {
      case MaintenanceStatus.scheduled:
        return 'Scheduled';
      case MaintenanceStatus.inProgress:
        return 'In Progress';
      case MaintenanceStatus.completed:
        return 'Completed';
    }
  }
}

/// A service visit performed (or scheduled) on a solar plate.
class MaintenanceRecord {
  MaintenanceRecord({
    required this.id,
    required this.panelId,
    required this.panelName,
    required this.type,
    required this.status,
    required this.note,
    required this.technician,
    required this.cost,
    required this.date,
  });

  final String id;
  final String panelId;
  final String panelName;
  final MaintenanceType type;
  final MaintenanceStatus status;
  final String note;
  final String technician;
  final double cost;
  final DateTime date;
}
