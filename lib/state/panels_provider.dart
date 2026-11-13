import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';
import '../data/datasources/remote/iot_device_datasource.dart';
import '../data/repositories/panel_repository_impl.dart';
import '../domain/entities/maintenance_record.dart';
import '../domain/entities/panel.dart';
import '../domain/entities/panel_fault.dart';
import '../domain/usecases/add_panel.dart';
import '../domain/usecases/get_panels.dart';
import '../domain/usecases/remove_panel.dart';
import '../domain/usecases/toggle_panel_power.dart';
import '../domain/usecases/toggle_system_power.dart';
import 'panel_filter.dart';

/// Central state of every solar plate + its live readings.
class PanelsProvider extends ChangeNotifier {
  PanelsProvider({
    required GetPanels getPanels,
    required TogglePanelPower togglePanelPower,
    required ToggleSystemPower toggleSystemPower,
    required AddPanel addPanel,
    required RemovePanel removePanel,
    required PanelRepositoryImpl repository,
    required IotDeviceDatasource iot,
  })  : _getPanels = getPanels,
        _togglePanelPower = togglePanelPower,
        _toggleSystemPower = toggleSystemPower,
        _addPanel = addPanel,
        _removePanel = removePanel,
        _repository = repository,
        _iot = iot;

  final GetPanels _getPanels;
  final TogglePanelPower _togglePanelPower;
  final ToggleSystemPower _toggleSystemPower;
  final AddPanel _addPanel;
  final RemovePanel _removePanel;
  final PanelRepositoryImpl _repository;
  final IotDeviceDatasource _iot;

  List<Panel> _panels = [];
  bool loading = false;
  PanelFilter filter = PanelFilter.all;
  String search = '';

  // ---------- getters ----------
  List<Panel> get panels => List.unmodifiable(_panels);

  List<Panel> get filteredPanels => applyPanelFilters(
        _panels,
        filter: filter,
        query: search,
      );

  int get total => _panels.length;

  int get producingCount =>
      _panels.where((p) => p.isProducing).length;

  int get faultedCount => _panels.where((p) => p.isFaulted).length;

  int get offlineCount =>
      _panels.where((p) => p.status == PanelStatus.offline).length;

  int get poweredOffCount =>
      _panels.where((p) => p.status == PanelStatus.off || !p.powerEnabled).length;

  double get totalPowerNow =>
      _panels.fold(0.0, (sum, p) => sum + p.power);

  double get todayKwh =>
      _panels.fold(0.0, (sum, p) => sum + p.energyTodayKwh);

  double get avgHealth {
    if (_panels.isEmpty) return 0;
    final int sum = _panels.fold(0, (s, p) => s + p.healthScore);
    return sum / _panels.length;
  }

  bool get systemOn => _panels.isNotEmpty && _panels.any((p) => p.powerEnabled);

  double get avgTemperature {
    final List<Panel> active =
        _panels.where((p) => p.power > 0).toList();
    if (active.isEmpty) return 0;
    return active.fold(0.0, (s, p) => s + p.temperature) / active.length;
  }

  double get avgIrradiance {
    final List<Panel> active =
        _panels.where((p) => p.power > 0).toList();
    if (active.isEmpty) return 0;
    return active.fold(0.0, (s, p) => s + p.irradiance) / active.length;
  }

  double get totalVoltage {
    // Strings add up in series — this is the summed string voltage.
    return _panels.fold(0.0, (s, p) => s + p.voltage);
  }

  double get totalCurrent =>
      _panels.fold(0.0, (s, p) => s + p.current);

  Panel? panelById(String id) {
    for (final Panel p in _panels) {
      if (p.id == id) return p;
    }
    return null;
  }

  // ---------- actions ----------
  Future<void> refresh() async {
    _panels = await _getPanels.execute();
    notifyListeners();
  }

  Future<void> setLoading(bool v) async {
    loading = v;
    notifyListeners();
  }

  void setFilter(PanelFilter f) {
    filter = f;
    notifyListeners();
  }

  void setSearch(String q) {
    search = q;
    notifyListeners();
  }

  Future<bool> togglePower(String panelId) async {
    final bool ok = await _togglePanelPower.execute(panelId);
    if (ok) await refresh();
    return ok;
  }

  Future<void> setSystemPower(bool enabled) async {
    await _toggleSystemPower.execute(enabled);
    await refresh();
  }

  Future<void> toggleMaintenance(String panelId) async {
    final Panel? panel = panelById(panelId);
    if (panel == null) return;
    await _repository.setMaintenanceMode(
        panelId, panel.status != PanelStatus.maintenance);
    await refresh();
  }

  Future<Panel?> addPanelRecord({
    required String name,
    required String model,
    required double ratedWatts,
    required String location,
  }) async {
    try {
      final Panel created = await _addPanel.execute(
        name: name,
        model: model,
        ratedWatts: ratedWatts,
        location: location,
      );
      AppLogger.i('Panels',
          'Registered ${created.name} (${created.id} / ${created.deviceId})');
      await refresh();
      return created;
    } catch (e, st) {
      AppLogger.e('Panels', 'addPanelRecord failed', e);
      AppLogger.e('Panels', 'stack', st);
      rethrow;
    }
  }

  Future<void> remove(String panelId) async {
    await _removePanel.execute(panelId);
    await refresh();
  }

  /// "Simulate damage" demo action: injects a random fault on a random
  /// healthy, powered plate and immediately evaluates alerts.
  Future<bool> simulateRandomFault() async {
    final List<Panel> candidates = _panels
        .where((p) => p.powerEnabled && !p.isFaulted && p.status == PanelStatus.online)
        .toList();
    if (candidates.isEmpty) return false;

    final Panel target = candidates[Random().nextInt(candidates.length)];
    const List<PanelFaultType> faults = [
      PanelFaultType.hotspot,
      PanelFaultType.soiling,
      PanelFaultType.partialShading,
      PanelFaultType.microCrack,
      PanelFaultType.openCircuit,
      PanelFaultType.bypassDiodeFailure,
      PanelFaultType.stringFailure,
      PanelFaultType.underPerformance,
    ];
    _iot.injectFault(target.deviceId, faults[Random().nextInt(faults.length)]);
    AppLogger.i('Panels', 'Injected fault on ${target.name}');
    return true;
  }

  /// Clears the fault of a plate ("Mark Repaired") and logs a repair visit.
  Future<void> markRepaired(String panelId) async {
    final Panel? panel = panelById(panelId);
    if (panel == null) return;
    _iot.clearFault(panel.deviceId);
    panel.activeFault = PanelFaultType.none;
    if (panel.status == PanelStatus.fault) panel.status = PanelStatus.online;
    panel.healthScore = panel.healthScore < 60 ? 60 : panel.healthScore;

    await _repository.addMaintenanceRecord(
      MaintenanceRecord(
        id: 'MNT-${DateTime.now().millisecondsSinceEpoch}',
        panelId: panel.id,
        panelName: panel.name,
        type: MaintenanceType.repair,
        status: MaintenanceStatus.completed,
        note: 'Fault repaired via app — plate restored to service.',
        technician: 'App Self-Service',
        cost: 0,
        date: DateTime.now(),
      ),
    );
    await _repository.persist();
    await refresh();
  }

  Future<void> scheduleMaintenance(
    String panelId,
    MaintenanceType type,
    String note,
  ) async {
    final Panel? panel = panelById(panelId);
    if (panel == null) return;
    await _repository.addMaintenanceRecord(
      MaintenanceRecord(
        id: 'MNT-${DateTime.now().millisecondsSinceEpoch}',
        panelId: panel.id,
        panelName: panel.name,
        type: type,
        status: MaintenanceStatus.scheduled,
        note: note,
        technician: 'To be assigned',
        cost: 0,
        date: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> saveDiagnosticReport(dynamic report) async {
    await _repository.saveDiagnosticReport(report.panelId, report);
    await refresh();
  }

  Future<void> resetDemoSystem() async {
    await _repository.resetToSeed();
    await refresh();
  }

  String nextPanelIdPreview() {
    return 'SP-${(total + 1).toString().padLeft(3, '0')} • device '
        'IOT-${AppConstants.demoPassword.hashCode.abs() % 899999 + 100000}';
  }
}
