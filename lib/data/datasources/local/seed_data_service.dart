import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../../../core/constants/app_assets.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/maintenance_record.dart';
import '../../../domain/entities/panel.dart';
import '../../../domain/entities/panel_reading.dart';
import '../../models/panel_model.dart';

/// Creates the factory demo system: 8 plates, synthetic day history,
/// realistic models and maintenance logs.
class SeedDataService {
  SeedDataService();

  static const List<({String name, String model, double watts, String loc})>
      _catalog = [
    (name: 'Rooftop A1', model: 'Longi Himo 6 580W', watts: 580, loc: 'Rooftop East'),
    (name: 'Rooftop A2', model: 'Longi Himo 6 580W', watts: 580, loc: 'Rooftop East'),
    (name: 'Rooftop B1', model: 'Jinko Tiger Neo 550W', watts: 550, loc: 'Rooftop West'),
    (name: 'Terrace C1', model: 'Canadian Solar 445W', watts: 445, loc: 'Terrace South'),
    (name: 'Garage D1', model: 'Trina Vertex 500W', watts: 500, loc: 'Garage Roof'),
    (name: 'Garden E1', model: 'Jinko Tiger Neo 550W', watts: 550, loc: 'Garden Pole'),
    (name: 'Battery Shed F1', model: 'Canadian Solar 445W', watts: 445, loc: 'Shed Roof'),
    (name: 'Boundary Wall G1', model: 'Trina Vertex 500W', watts: 500, loc: 'Boundary Wall'),
  ];

  /// Tries the bundled asset registry first, falls back to the catalog.
  Future<List<Panel>> createDefaultPanels() async {
    List<Panel> panels;
    try {
      final String raw = await rootBundle.loadString(AppAssets.seedPanels);
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      panels = PanelModel.listToEntity(list);
      AppLogger.i('Seed', 'Loaded ${panels.length} panels from asset registry');
    } catch (e) {
      AppLogger.i('Seed', 'Asset registry unavailable, using catalog seed');
      panels = _catalogPanels();
    }

    for (final Panel p in panels) {
      _enrichWithHistory(p);
      _enrichWithMaintenance(p);
    }
    return panels;
  }

  List<Panel> _catalogPanels() {
    final DateTime now = DateTime.now();
    final List<Panel> panels = [];
    for (int i = 0; i < _catalog.length; i++) {
      final item = _catalog[i];
      panels.add(
        Panel(
          id: 'SP-${(i + 1).toString().padLeft(3, '0')}',
          name: item.name,
          model: item.model,
          ratedWatts: item.watts,
          deviceId:
              'IOT-${(100000 + Random(i * 7919).nextInt(899999)).toString()}',
          location: item.loc,
          installedOn: now.subtract(Duration(days: 420 + i * 13)),
          lastMaintenance: now.subtract(Duration(days: 45 + i * 9)),
          energyTodayKwh: 2.1 + i * 0.14,
          lifetimeEnergyKwh: 1180.0 + i * 96.0,
          healthScore: i == 2 ? 78 : 94 - (i % 3) * 2,
        ),
      );
    }
    return panels;
  }

  /// Generates a believable 24h curve so charts are alive on first launch.
  void _enrichWithHistory(Panel panel) {
    if (panel.history.isNotEmpty) return;
    final DateTime now = DateTime.now();
    for (int h = 23; h >= 0; h--) {
      final DateTime ts = now.subtract(Duration(hours: h));
      final double hour = ts.hour + ts.minute / 60.0;
      double sun = 0;
      if (hour > 6 && hour < 19) {
        sun = AppDateTimeUtils.solarFactor();
        if (h > 12) sun = sun * 0.96; // slight day-to-day variation
      }
      final double factor = panel.ratedWatts / 580.0;
      final double voltage = sun > 0.02 ? 39.5 + sun * 1.8 : 0.4;
      final double power = panel.ratedWatts * sun * 0.93 * factor;
      panel.history.add(
        PanelReading(
          timestamp: ts,
          voltage: voltage,
          current: voltage > 1 ? power / voltage : 0,
          power: power,
          temperature: 22 + sun * 30 + (panel.id.hashCode % 3),
          irradiance: sun * 1000,
          efficiency: sun > 0.02 ? 92 + sun * 4 : 0,
        ),
      );
    }
  }

  /// A couple of past maintenance entries so the log is not empty.
  void _enrichWithMaintenance(Panel panel) {
    if (panel.maintenanceLog.isNotEmpty) return;
    final DateTime now = DateTime.now();
    panel.maintenanceLog.addAll([
      MaintenanceRecord(
        id: 'MNT-${panel.id}-1',
        panelId: panel.id,
        panelName: panel.name,
        type: MaintenanceType.cleaning,
        status: MaintenanceStatus.completed,
        note: 'Routine surface cleaning, output restored to 100%.',
        technician: 'Ali Raza (SolarFix)',
        cost: 800,
        date: now.subtract(const Duration(days: 41)),
      ),
      MaintenanceRecord(
        id: 'MNT-${panel.id}-2',
        panelId: panel.id,
        panelName: panel.name,
        type: MaintenanceType.inspection,
        status: MaintenanceStatus.completed,
        note: 'Semi-annual inspection: wiring, earthing and diodes checked.',
        technician: 'Bilal Khan (SolarFix)',
        cost: 0,
        date: now.subtract(const Duration(days: 120)),
      ),
    ]);
  }
}
