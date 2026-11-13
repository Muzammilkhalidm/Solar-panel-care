import '../../data/repositories/panel_repository_impl.dart';

/// Toggles the power switch of one plate from the mobile app.
class TogglePanelPower {
  TogglePanelPower(this._repo);
  final PanelRepositoryImpl _repo;

  Future<bool> execute(String panelId) async {
    final panel = await _repo.getPanel(panelId);
    if (panel == null) return false;
    await _repo.setPowerEnabled(panelId, !panel.powerEnabled);
    return true;
  }
}
