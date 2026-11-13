import '../../domain/entities/alert.dart';
import '../../domain/entities/panel_fault.dart';
import '../../domain/repositories/alert_repository.dart';
import '../datasources/local/alert_local_datasource.dart';

/// In-memory alert cache persisted to local storage.
class AlertRepositoryImpl implements AlertRepository {
  AlertRepositoryImpl(this._local);

  final AlertLocalDatasource _local;
  List<Alert>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final List<Alert>? stored = await _local.loadAlerts();
    if (stored != null && stored.isNotEmpty) {
      _cache = stored;
    } else {
      _cache = _seedResolvedHistory();
      await persist();
    }
  }

  /// Two resolved historical alerts so the log shows past activity.
  List<Alert> _seedResolvedHistory() {
    final DateTime now = DateTime.now();
    return [
      Alert(
        id: 'ALT-SEED-1',
        panelId: 'SP-003',
        panelName: 'Rooftop B1',
        title: 'Dust & Soiling detected',
        message:
            'Output had dropped below the performance threshold. A cleaning '
            'visit restored full production.',
        severity: AlertSeverity.medium,
        type: AlertType.fault,
        faultType: PanelFaultType.soiling,
        createdAt: now.subtract(const Duration(days: 6, hours: 4)),
        resolved: true,
        resolvedAt: now.subtract(const Duration(days: 5, hours: 2)),
      ),
      Alert(
        id: 'ALT-SEED-2',
        panelId: 'SP-006',
        panelName: 'Garden E1',
        title: 'Partial Shading cleared',
        message:
            'A tree branch was shadowing the plate in the afternoon. '
            'Branch trimmed by the customer.',
        severity: AlertSeverity.low,
        type: AlertType.fault,
        faultType: PanelFaultType.partialShading,
        createdAt: now.subtract(const Duration(days: 12, hours: 6)),
        resolved: true,
        resolvedAt: now.subtract(const Duration(days: 11, hours: 1)),
      ),
    ];
  }

  @override
  Future<List<Alert>> getAlerts() async {
    await _ensureLoaded();
    final List<Alert> sorted = List<Alert>.from(_cache!);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> addAlert(Alert alert) async {
    await _ensureLoaded();
    _cache!.add(alert);
    await persist();
  }

  @override
  Future<bool> hasUnresolvedOfType(
    String panelId,
    AlertType type, {
    PanelFaultType? faultType,
  }) async {
    await _ensureLoaded();
    for (final Alert a in _cache!) {
      if (a.panelId == panelId && a.type == type && a.isActive) {
        if (faultType == null || a.faultType == faultType) return true;
      }
    }
    return false;
  }

  @override
  Future<void> resolveAlert(String alertId) async {
    await _ensureLoaded();
    for (final Alert a in _cache!) {
      if (a.id == alertId) {
        a.resolved = true;
        a.resolvedAt = DateTime.now();
      }
    }
    await persist();
  }

  @override
  Future<void> resolveForPanel(String panelId) async {
    await _ensureLoaded();
    for (final Alert a in _cache!) {
      if (a.panelId == panelId && a.isActive) {
        a.resolved = true;
        a.resolvedAt = DateTime.now();
      }
    }
    await persist();
  }

  @override
  Future<void> resolveAll() async {
    await _ensureLoaded();
    for (final Alert a in _cache!) {
      if (a.isActive) {
        a.resolved = true;
        a.resolvedAt = DateTime.now();
      }
    }
    await persist();
  }

  @override
  Future<void> clearResolved() async {
    await _ensureLoaded();
    _cache!.removeWhere((a) => a.resolved);
    await persist();
  }

  @override
  Future<void> clearAll() async {
    _cache = [];
    await persist();
  }

  Future<void> persist() async {
    if (_cache == null) return;
    await _local.saveAlerts(_cache!);
  }
}
