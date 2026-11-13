import '../../data/repositories/panel_repository_impl.dart';
import '../entities/panel.dart';

/// Fetches a single panel by id.
class GetPanelById {
  GetPanelById(this._repo);
  final PanelRepositoryImpl _repo;

  Future<Panel?> execute(String panelId) => _repo.getPanel(panelId);
}
