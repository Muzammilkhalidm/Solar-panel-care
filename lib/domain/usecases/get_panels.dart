import '../../data/repositories/panel_repository_impl.dart';
import '../entities/panel.dart';

/// Loads the full list of monitored solar plates.
class GetPanels {
  GetPanels(this._repo);
  final PanelRepositoryImpl _repo;

  Future<List<Panel>> execute() => _repo.getPanels();
}
