import '../entities/alert.dart';
import '../entities/panel_fault.dart';

/// Contract for alert storage.
abstract class AlertRepository {
  Future<List<Alert>> getAlerts();

  Future<void> addAlert(Alert alert);

  /// Deduplication guard — true if an active alert of this type already
  /// exists for the panel.
  Future<bool> hasUnresolvedOfType(
    String panelId,
    AlertType type, {
    PanelFaultType? faultType,
  });

  Future<void> resolveAlert(String alertId);

  Future<void> resolveForPanel(String panelId);

  Future<void> resolveAll();

  Future<void> clearResolved();

  Future<void> clearAll();
}
