import '../../domain/entities/energy_stats.dart';

/// JSON export/import support for [EnergyStats] (used by the backup note
/// in the docs and future sharing features).
class EnergyStatsModel {
  EnergyStatsModel._();

  static Map<String, dynamic> toJson(EnergyStats s) => {
        'todayKwh': s.todayKwh,
        'weekKwh': s.weekKwh,
        'monthKwh': s.monthKwh,
        'lifetimeKwh': s.lifetimeKwh,
        'currentPowerW': s.currentPowerW,
        'peakPowerW': s.peakPowerW,
        'avgEfficiency': s.avgEfficiency,
        'co2SavedKg': s.co2SavedKg,
        'moneySavedPkr': s.moneySavedPkr,
        'treesEquivalent': s.treesEquivalent,
        'activePanels': s.activePanels,
        'totalPanels': s.totalPanels,
        'faultedPanels': s.faultedPanels,
        'offlinePanels': s.offlinePanels,
      };
}
