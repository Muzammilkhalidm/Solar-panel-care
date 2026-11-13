import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/alert.dart';
import '../../../state/alerts_provider.dart';
import 'severity_badge.dart';

/// One alert row in the history list.
class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: alert.isActive ? p.card : p.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert.isActive
              ? severityColor(alert.severity).withOpacity(0.45)
              : p.cardBorder,
        ),
        boxShadow: alert.isActive ? p.cardShadow : null,
      ),
      child: InkWell(
        onTap: () => openAlertDetailFromTile(context, alert),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: severityColor(alert.severity).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                alertTypeIcon(alert.type),
                size: 20,
                color: severityColor(alert.severity),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: p.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SeverityBadge(severity: alert.severity, compact: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.message,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: p.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.solar_power,
                          size: 13, color: p.textFaint),
                      const SizedBox(width: 4),
                      Text(
                        '${alert.panelName} • ${AppFormatters.timeAgo(alert.createdAt)}',
                        style: TextStyle(fontSize: 10.5, color: p.textFaint),
                      ),
                      const Spacer(),
                      if (alert.resolved)
                        const Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 13, color: Color(0xFF2E9E5B)),
                            SizedBox(width: 4),
                            Text(
                              'Resolved',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E9E5B),
                              ),
                            ),
                          ],
                        )
                      else
                        TextButton(
                          onPressed: () => context
                              .read<AlertsProvider>()
                              .resolve(alert.id),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(0, 28),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                          ),
                          child: const Text(
                            'Resolve',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Local navigation helper (kept separate to avoid circular import with
/// alerts_screen).
void openAlertDetailFromTile(BuildContext context, Alert alert) {
  Navigator.pushNamed(context, '/alerts/detail', arguments: alert.id);
}
