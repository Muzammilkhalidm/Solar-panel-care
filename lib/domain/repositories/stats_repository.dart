import '../entities/energy_stats.dart';
import '../entities/panel_reading.dart';

/// Contract for aggregated energy statistics.
abstract class StatsRepository {
  Future<EnergyStats> getEnergyStats();

  /// In-memory system-wide production history (for dashboard chart).
  List<PanelReading> getSystemHistory();

  void recordSystemSnapshot(double totalPowerW, double avgEfficiency);

  /// kWh totals for the last 7 days (index 6 = today, live).
  Future<List<double>> getWeeklyEnergy();
}
