import '../../data/repositories/alert_repository_impl.dart';

/// Marks one alert as resolved.
class ResolveAlert {
  ResolveAlert(this._repo);
  final AlertRepositoryImpl _repo;

  Future<void> execute(String alertId) => _repo.resolveAlert(alertId);
}
