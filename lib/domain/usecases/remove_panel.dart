import '../../data/repositories/panel_repository_impl.dart';

/// Removes a plate (and its IoT device) from monitoring.
class RemovePanel {
  RemovePanel(this._repo);
  final PanelRepositoryImpl _repo;

  Future<void> execute(String panelId) => _repo.removePanel(panelId);
}
