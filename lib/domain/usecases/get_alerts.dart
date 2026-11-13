import '../../data/repositories/alert_repository_impl.dart';
import '../entities/alert.dart';

/// Loads all alerts (newest first).
class GetAlerts {
  GetAlerts(this._repo);
  final AlertRepositoryImpl _repo;

  Future<List<Alert>> execute() => _repo.getAlerts();
}
