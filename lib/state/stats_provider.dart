import 'package:flutter/foundation.dart';

import '../data/repositories/stats_repository_impl.dart';
import '../domain/entities/energy_stats.dart';
import '../domain/entities/panel_reading.dart';
import '../domain/usecases/get_energy_stats.dart';

/// Dashboard/analytics numbers: aggregated stats + live system history.
class StatsProvider extends ChangeNotifier {
  StatsProvider({
    required GetEnergyStats getEnergyStats,
    required StatsRepositoryImpl repository,
  })  : _getEnergyStats = getEnergyStats,
        _repository = repository;

  final GetEnergyStats _getEnergyStats;
  final StatsRepositoryImpl _repository;

  EnergyStats? stats;
  List<PanelReading> systemHistory = [];
  List<double> weeklyEnergy = List<double>.filled(7, 0);

  Future<void> refresh() async {
    stats = await _getEnergyStats.execute();
    systemHistory = _repository.getSystemHistory().toList();
    weeklyEnergy = await _repository.getWeeklyEnergy();
    notifyListeners();
  }
}
