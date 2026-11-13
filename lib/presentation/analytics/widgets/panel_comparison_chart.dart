import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../state/panels_provider.dart';
import '../../../domain/entities/panel.dart';

/// Horizontal comparison of today's kWh per plate.
class PanelComparisonChart extends StatelessWidget {
  const PanelComparisonChart({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final panels = context.watch<PanelsProvider>().panels;

    if (panels.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Panel> sorted = List<Panel>.from(panels)
      ..sort((a, b) => b.energyTodayKwh.compareTo(a.energyTodayKwh));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.cardBorder),
      ),
      child: Column(
        children: sorted.map((panel) {
          final double max = sorted.first.energyTodayKwh;
          final double ratio =
              max > 0 ? panel.energyTodayKwh / max : 0.0;
          final bool faulted = panel.isFaulted;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 104,
                  child: Text(
                    panel.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: p.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: p.surfaceAlt,
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio.clamp(0.02, 1.0),
                        child: Container(
                          height: 18,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: faulted
                                  ? [
                                      const Color(0xFFE5484D),
                                      const Color(0xFFE5484D)
                                          .withOpacity(0.6),
                                    ]
                                  : [
                                      const Color(0xFFF7A021),
                                      const Color(0xFFFF7E2D),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 64,
                  child: Text(
                    AppFormatters.kwh(panel.energyTodayKwh),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: faulted
                          ? const Color(0xFFE5484D)
                          : p.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
