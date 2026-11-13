import '../../data/repositories/stats_repository_impl.dart';
import '../entities/energy_stats.dart';

/// Computes the aggregated energy statistics for the dashboard.
class GetEnergyStats {
  GetEnergyStats(this._repo);
  final StatsRepositoryImpl _repo;

  Future<EnergyStats> execute() => _repo.getEnergyStats();
}
