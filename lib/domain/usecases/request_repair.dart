import '../../data/repositories/alert_repository_impl.dart';
import '../../data/repositories/panel_repository_impl.dart';
import '../entities/alert.dart';
import '../entities/maintenance_record.dart';
import '../entities/panel_fault.dart';

/// From an alert, schedules a technician visit (repair request) and
/// resolves the alert. Returns the created maintenance record.
class RequestRepair {
  RequestRepair(this._panelRepo, this._alertRepo);

  final PanelRepositoryImpl _panelRepo;
  final AlertRepositoryImpl _alertRepo;

  Future<MaintenanceRecord?> execute({required Alert alert, String? note}) async {
    final panels = await _panelRepo.getPanels();
    final bool exists = panels.any((p) => p.id == alert.panelId);
    if (!exists) return null;

    final int stamp = DateTime.now().millisecondsSinceEpoch;
    final MaintenanceRecord record = MaintenanceRecord(
      id: 'MNT-$stamp',
      panelId: alert.panelId,
      panelName: alert.panelName,
      type: MaintenanceType.repair,
      status: MaintenanceStatus.scheduled,
      note:
          note ?? 'Repair requested from mobile app for ${alert.faultType.label}',
      technician: 'To be assigned',
      cost: 0,
      date: DateTime.now(),
    );

    await _panelRepo.addMaintenanceRecord(record);
    await _alertRepo.resolveAlert(alert.id);
    return record;
  }
}
