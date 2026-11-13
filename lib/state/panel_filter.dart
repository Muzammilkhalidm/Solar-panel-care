import '../domain/entities/panel.dart';

/// Filter chips shown on the panels list screen.
enum PanelFilter { all, producing, fault, offline, off, maintenance }

extension PanelFilterX on PanelFilter {
  String get label {
    switch (this) {
      case PanelFilter.all:
        return 'All';
      case PanelFilter.producing:
        return 'Producing';
      case PanelFilter.fault:
        return 'Fault';
      case PanelFilter.offline:
        return 'Offline';
      case PanelFilter.off:
        return 'Powered Off';
      case PanelFilter.maintenance:
        return 'Maintenance';
    }
  }
}

/// Applies search + filter to the panel list.
List<Panel> applyPanelFilters(
  List<Panel> panels, {
  required PanelFilter filter,
  required String query,
}) {
  final String q = query.trim().toLowerCase();
  return panels.where((Panel p) {
    final bool matchesQuery = q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        p.model.toLowerCase().contains(q) ||
        p.location.toLowerCase().contains(q) ||
        p.deviceId.toLowerCase().contains(q);
    if (!matchesQuery) return false;

    switch (filter) {
      case PanelFilter.all:
        return true;
      case PanelFilter.producing:
        return p.isProducing;
      case PanelFilter.fault:
        return p.isFaulted;
      case PanelFilter.offline:
        return p.status == PanelStatus.offline;
      case PanelFilter.off:
        return p.status == PanelStatus.off || !p.powerEnabled;
      case PanelFilter.maintenance:
        return p.status == PanelStatus.maintenance;
    }
  }).toList();
}
