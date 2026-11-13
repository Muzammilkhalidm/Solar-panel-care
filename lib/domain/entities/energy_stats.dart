import '../../core/constants/app_constants.dart';
import 'panel.dart';

/// Aggregated numbers for the dashboard / analytics screens.
class EnergyStats {
  EnergyStats({
    required this.todayKwh,
    required this.weekKwh,
    required this.monthKwh,
    required this.lifetimeKwh,
    required this.currentPowerW,
    required this.peakPowerW,
    required this.avgEfficiency,
    required this.co2SavedKg,
    required this.moneySavedPkr,
    required this.treesEquivalent,
    required this.activePanels,
    required this.totalPanels,
    required this.faultedPanels,
    required this.offlinePanels,
  });

  final double todayKwh;
  final double weekKwh;
  final double monthKwh;
  final double lifetimeKwh;
  final double currentPowerW;
  final double peakPowerW;
  final double avgEfficiency;
  final double co2SavedKg;
  final double moneySavedPkr;
  final int treesEquivalent;
  final int activePanels;
  final int totalPanels;
  final int faultedPanels;
  final int offlinePanels;

  factory EnergyStats.fromPanels(
    List<Panel> panels, {
    required List<double> weeklyTotals,
  }) {
    double today = 0;
    double current = 0;
    double lifetime = 0;
    double effSum = 0;
    int producing = 0;
    int faulted = 0;
    int offline = 0;
    double peak = 0;

    for (final p in panels) {
      today += p.energyTodayKwh;
      lifetime += p.lifetimeEnergyKwh;
      current += p.power;
      if (p.power > 0) {
        effSum += p.efficiency;
        producing++;
      }
      if (p.isFaulted) faulted++;
      if (p.status == PanelStatus.offline) offline++;
      if (p.history.isNotEmpty) {
        peak = peak < 0 ? 0 : peak;
        for (final r in p.history) {
          if (r.power > peak) peak = r.power;
        }
      }
    }

    final double week = weeklyTotals.fold(0.0, (a, b) => a + b);
    final double co2 = today * AppConstants.co2KgPerKwh;

    return EnergyStats(
      todayKwh: today,
      weekKwh: week,
      monthKwh: week * 4.3,
      lifetimeKwh: lifetime,
      currentPowerW: current,
      peakPowerW: peak,
      avgEfficiency: producing > 0 ? effSum / producing : 0,
      co2SavedKg: co2,
      moneySavedPkr: today * AppConstants.pkrPerKwh,
      treesEquivalent: (co2 / AppConstants.kgCo2PerTreeYear).round(),
      activePanels: producing,
      totalPanels: panels.length,
      faultedPanels: faulted,
      offlinePanels: offline,
    );
  }
}
