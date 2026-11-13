import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../../domain/entities/panel.dart';
import '../../../state/panels_provider.dart';
import '../../panels/widgets/panel_card.dart';

/// Horizontal strip of live plate mini-cards.
class PanelsPreviewStrip extends StatelessWidget {
  const PanelsPreviewStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final panels = context.watch<PanelsProvider>();
    final List<Panel> list = panels.panels.take(6).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Plates Status',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.addPanel),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7E2D).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF7E2D).withOpacity(0.35),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 15, color: Color(0xFFFF7E2D)),
                    SizedBox(width: 5),
                    Text(
                      'Add Plate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE85D04),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 172,
          child: list.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    color: p.surfaceAlt,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: p.cardBorder),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.solar_power_outlined,
                            size: 30, color: p.textFaint),
                        const SizedBox(height: 8),
                        Text(
                          'No plates registered yet',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: p.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) => PanelCard(
                    panel: list[i],
                    width: 220,
                  ),
                ),
        ),
      ],
    );
  }
}
