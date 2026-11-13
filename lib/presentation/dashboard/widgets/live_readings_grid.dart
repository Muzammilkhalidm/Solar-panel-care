import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../state/panels_provider.dart';

/// Live electrical readings of the whole system.
class LiveReadingsGrid extends StatelessWidget {
  const LiveReadingsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final panels = context.watch<PanelsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Live System Readings',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'String Voltage',
                value: AppFormatters.volts(panels.totalVoltage),
                icon: Icons.electrical_services,
                color: const Color(0xFF2E7DD1),
                compact: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                label: 'Total Current',
                value: AppFormatters.amps(panels.totalCurrent),
                icon: Icons.electric_bolt,
                color: const Color(0xFFFF7E2D),
                compact: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Avg Cell Temp',
                value: panels.avgTemperature == 0
                    ? '—'
                    : AppFormatters.celsius(panels.avgTemperature),
                icon: Icons.device_thermostat,
                color: const Color(0xFFE5484D),
                compact: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(
                label: 'Avg Irradiance',
                value: panels.avgIrradiance == 0
                    ? '—'
                    : AppFormatters.irradiance(panels.avgIrradiance),
                icon: Icons.wb_sunny,
                color: const Color(0xFFF7A021),
                compact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
