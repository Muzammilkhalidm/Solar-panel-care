import '../../data/repositories/panel_repository_impl.dart';

/// Master system switch — every plate ON or OFF at once.
class ToggleSystemPower {
  ToggleSystemPower(this._repo);
  final PanelRepositoryImpl _repo;

  Future<void> execute(bool enabled) => _repo.setAllPowerEnabled(enabled);
}
