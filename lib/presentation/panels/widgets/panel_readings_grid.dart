import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../domain/entities/panel.dart';

/// 2x2 live reading grid for one plate.
class PanelReadingsGrid extends StatelessWidget {
  const PanelReadingsGrid({super.key, required this.panel});

  final Panel panel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Voltage',
                value: AppFormatters.volts(panel.voltage),
                icon: Icons.electrical_services,
                color: const Color(0xFF2E7DD1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                label: 'Current',
                value: AppFormatters.amps(panel.current),
                icon: Icons.electric_bolt,
                color: const Color(0xFFFF7E2D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Power Output',
                value: AppFormatters.watts(panel.power),
                icon: Icons.solar_power,
                color: const Color(0xFF2E9E5B),
                subtitle:
                    'of ${panel.ratedWatts.toStringAsFixed(0)} W rated',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                label: 'Cell Temp',
                value: AppFormatters.celsius(panel.temperature),
                icon: Icons.device_thermostat,
                color: panel.temperature > 70
                    ? const Color(0xFFE5484D)
                    : const Color(0xFFF5A524),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Irradiance',
                value: AppFormatters.irradiance(panel.irradiance),
                icon: Icons.wb_sunny,
                color: const Color(0xFFF5A524),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                label: 'Efficiency',
                value: AppFormatters.percent(panel.efficiency),
                icon: Icons.speed,
                color: const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
