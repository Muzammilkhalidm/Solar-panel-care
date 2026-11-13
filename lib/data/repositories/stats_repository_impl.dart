import 'dart:convert';
import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';
import '../../domain/entities/energy_stats.dart';
import '../../domain/entities/panel.dart';
import '../../domain/entities/panel_reading.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/local/local_database.dart';
import 'panel_repository_impl.dart';

/// Aggregates panel state into energy statistics and keeps the in-memory
/// system-wide production history used by the dashboard chart.
class StatsRepositoryImpl implements StatsRepository {
  StatsRepositoryImpl(this._db, this._panelRepo);

  final LocalDatabase _db;
  final PanelRepositoryImpl _panelRepo;

  final List<PanelReading> _systemHistory = <PanelReading>[];
  bool _historySeeded = false;

  static const List<double> _seedWeek = [
    16.4, 18.2, 15.9, 19.3, 21.0, 17.6, 20.2,
  ];

  @override
  Future<EnergyStats> getEnergyStats() async {
    final List<Panel> panels = await _panelRepo.getPanels();
    return EnergyStats.fromPanels(panels, weeklyTotals: await getWeeklyEnergy());
  }

  @override
  List<PanelReading> getSystemHistory() {
    _seedHistoryIfEmpty();
    return List<PanelReading>.unmodifiable(_systemHistory);
  }

  @override
  void recordSystemSnapshot(double totalPowerW, double avgEfficiency) {
    _seedHistoryIfEmpty();
    _systemHistory.add(
      PanelReading(
        timestamp: DateTime.now(),
        voltage: 0,
        current: 0,
        power: totalPowerW,
        temperature: 0,
        irradiance: 0,
        efficiency: avgEfficiency,
      ),
    );
    if (_systemHistory.length > AppConstants.maxSystemSnapshots) {
      _systemHistory.removeAt(0);
    }
  }

  @override
  Future<List<double>> getWeeklyEnergy() async {
    final List<double> stored = _readWeekly();
    final List<double> out = List<double>.filled(7, 0);

    // index 6 == today (live), older days come from stored seed/actuals.
    final DateTime now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final DateTime day = now.subtract(Duration(days: i));
      final int wd = day.weekday - 1; // 0 = Monday
      if (i == 0) {
        final List<Panel> panels = await _panelRepo.getPanels();
        out[i] = panels.fold(0.0, (s, p) => s + p.energyTodayKwh);
      } else {
        out[i] = stored[wd];
      }
    }
    return out;
  }

  List<double> _readWeekly() {
    try {
      final String? raw = _db.read(LocalDatabase.kWeekly);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        if (list.length == 7) {
          return list.map((e) => (e as num).toDouble()).toList();
        }
      }
    } catch (_) {}
    return List<double>.from(_seedWeek);
  }

  void _seedHistoryIfEmpty() {
    if (_historySeeded && _systemHistory.isNotEmpty) return;
    final Random rnd = Random(42);
    final DateTime now = DateTime.now();
    for (int i = AppConstants.maxSystemSnapshots - 12; i >= 1; i--) {
      final double sun = _pseudoSolar(i);
      _systemHistory.add(
        PanelReading(
          timestamp: now.subtract(Duration(minutes: i * 4)),
          voltage: 0,
          current: 0,
          power: 3200 * sun + rnd.nextDouble() * 120,
          temperature: 0,
          irradiance: 0,
          efficiency: 88 + sun * 6 + rnd.nextDouble() * 2,
        ),
      );
    }
    _historySeeded = true;
  }

  double _pseudoSolar(int minutesAgo) {
    final DateTime t = DateTime.now().subtract(Duration(minutes: minutesAgo * 4));
    final double hour = t.hour + t.minute / 60.0;
    if (hour <= 6 || hour >= 19) return 0.35; // seed keeps the chart visible
    final double x = (hour - 6) / 13;
    return 0.35 + 0.55 * (x < 0 || x > 1 ? 0.2 : x * (1 - x) * 4).clampRange(0, 1);
  }
}
