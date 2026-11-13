import 'dart:math';

import '../../data/repositories/panel_repository_impl.dart';
import '../entities/panel.dart';

/// Registers a new solar plate + its IoT device into the monitoring system.
class AddPanel {
  AddPanel(this._repo);
  final PanelRepositoryImpl _repo;

  Future<Panel> execute({
    required String name,
    required String model,
    required double ratedWatts,
    required String location,
  }) async {
    final panels = await _repo.getPanels();

    // Collision-free id: always move past the highest existing SP-xxx
    // (fixes duplicate ids after plate removal, which used to break the
    // register-plate flow).
    int maxNumber = 0;
    final RegExp idPattern = RegExp(r'^SP-(\d+)$');
    for (final Panel p in panels) {
      final Match? m = idPattern.firstMatch(p.id);
      if (m != null) {
        final int n = int.tryParse(m.group(1)!) ?? 0;
        if (n > maxNumber) maxNumber = n;
      } else {
        maxNumber++;
      }
    }
    final String id = 'SP-${(maxNumber + 1).toString().padLeft(3, '0')}';
    final String deviceId =
        'IOT-${_randomHex(6).toUpperCase()}';

    final Panel panel = Panel(
      id: id,
      name: name,
      model: model,
      ratedWatts: ratedWatts,
      deviceId: deviceId,
      location: location,
      installedOn: DateTime.now(),
      lastMaintenance: DateTime.now(),
    );

    await _repo.addPanel(panel);
    return panel;
  }

  String _randomHex(int length) {
    const String chars = '0123456789ABCDEF';
    final Random rnd = Random.secure();
    return List.generate(length, (_) => chars[rnd.nextInt(16)]).join();
  }
}
