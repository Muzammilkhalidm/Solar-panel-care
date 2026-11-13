import '../entities/diagnostic_report.dart';
import '../entities/maintenance_record.dart';
import '../entities/panel.dart';

/// Contract for panel storage + live state (implemented in the data layer).
abstract class PanelRepository {
  Future<List<Panel>> getPanels();

  Future<Panel?> getPanel(String id);

  Future<void> addPanel(Panel panel);

  Future<void> removePanel(String id);

  Future<void> setPowerEnabled(String panelId, bool enabled);

  Future<void> setAllPowerEnabled(bool enabled);

  Future<void> setMaintenanceMode(String panelId, bool maintenance);

  Future<void> addMaintenanceRecord(MaintenanceRecord record);

  Future<void> saveDiagnosticReport(String panelId, DiagnosticReport report);

  /// Persists the current in-memory state (called throttled by the engine).
  Future<void> persist();

  /// Wipes local data and restores the factory demo system.
  Future<void> resetToSeed();
}
