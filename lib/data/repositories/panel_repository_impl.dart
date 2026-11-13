import '../../core/utils/logger.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../../domain/entities/maintenance_record.dart';
import '../../domain/entities/panel.dart';
import '../../domain/repositories/panel_repository.dart';
import '../datasources/local/panel_local_datasource.dart';
import '../datasources/local/seed_data_service.dart';

/// In-memory cache of the live panel objects, persisted (throttled) to
/// local storage. The IoT engine mutates the cached objects directly for
/// maximum tick performance, then calls [persist].
class PanelRepositoryImpl implements PanelRepository {
  PanelRepositoryImpl(this._local, this._seed);

  final PanelLocalDatasource _local;
  final SeedDataService _seed;

  List<Panel>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final List<Panel>? stored = await _local.loadPanels();
    if (stored != null && stored.isNotEmpty) {
      _cache = stored;
    } else {
      _cache = await _seed.createDefaultPanels();
      await persist();
      AppLogger.i('PanelRepo', 'Seeded factory system (${_cache!.length} plates)');
    }
  }

  @override
  Future<List<Panel>> getPanels() async {
    await _ensureLoaded();
    return _cache!;
  }

  @override
  Future<Panel?> getPanel(String id) async {
    await _ensureLoaded();
    for (final Panel p in _cache!) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  Future<void> addPanel(Panel panel) async {
    await _ensureLoaded();
    _cache!.add(panel);
    await persist();
  }

  @override
  Future<void> removePanel(String id) async {
    await _ensureLoaded();
    _cache!.removeWhere((p) => p.id == id);
    await persist();
  }

  @override
  Future<void> setPowerEnabled(String panelId, bool enabled) async {
    final panel = await getPanel(panelId);
    if (panel == null) return;
    panel.powerEnabled = enabled;
    if (!enabled) {
      panel.power = 0;
      panel.current = 0;
      panel.voltage = 0;
      panel.irradiance = 0;
      panel.efficiency = 0;
      panel.status = PanelStatus.off;
    }
    await persist();
  }

  @override
  Future<void> setAllPowerEnabled(bool enabled) async {
    await _ensureLoaded();
    for (final Panel p in _cache!) {
      p.powerEnabled = enabled;
      if (!enabled) {
        p.power = 0;
        p.current = 0;
        p.voltage = 0;
        p.irradiance = 0;
        p.efficiency = 0;
        p.status = PanelStatus.off;
      }
    }
    await persist();
  }

  @override
  Future<void> setMaintenanceMode(String panelId, bool maintenance) async {
    final panel = await getPanel(panelId);
    if (panel == null) return;
    panel.status =
        maintenance ? PanelStatus.maintenance : PanelStatus.online;
    await persist();
  }

  @override
  Future<void> addMaintenanceRecord(MaintenanceRecord record) async {
    final panel = await getPanel(record.panelId);
    if (panel == null) return;
    panel.maintenanceLog.insert(0, record);
    panel.lastMaintenance = record.date;
    await persist();
  }

  @override
  Future<void> saveDiagnosticReport(String panelId, DiagnosticReport report) async {
    final panel = await getPanel(panelId);
    if (panel == null) return;
    panel.lastDiagnostic = report;
    await persist();
  }

  @override
  Future<void> persist() async {
    if (_cache == null) return;
    await _local.savePanels(_cache!);
  }

  @override
  Future<void> resetToSeed() async {
    _cache = await _seed.createDefaultPanels();
    await persist();
  }
}
