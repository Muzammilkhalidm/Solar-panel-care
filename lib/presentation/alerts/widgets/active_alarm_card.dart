import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../domain/entities/alert.dart';
import '../../../state/alerts_provider.dart';

/// Pulsing red card for the loudest active alert.
class ActiveAlarmCard extends StatefulWidget {
  const ActiveAlarmCard({super.key, required this.alert});

  final Alert alert;

  @override
  State<ActiveAlarmCard> createState() => _ActiveAlarmCardState();
}

class _ActiveAlarmCardState extends State<ActiveAlarmCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertsProvider>();
    return FadeTransition(
      opacity: Tween<double>(begin: 0.88, end: 1).animate(_c),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE5484D), Color(0xFFB91C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE5484D).withOpacity(0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'EMERGENCY — PLATE NEEDS ATTENTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                if (alerts.alarmRinging)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ALARM 🔔',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.alert.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppFormatters.timeAgo(widget.alert.createdAt)} • '
              '${widget.alert.panelName}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 11.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => alerts.stopAlarm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFB91C1C),
                      minimumSize: const Size(0, 40),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.alarm_off, size: 18),
                    label: const Text(
                      'Stop Alarm',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 12.5),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final record = await alerts
                          .requestTechnician(widget.alert);
                      if (!context.mounted) return;
                      AppSnackBar.info(
                        record == null
                            ? 'Could not schedule the visit.'
                            : 'Technician visit scheduled — '
                                'record ${record.id}',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      minimumSize: const Size(0, 40),
                    ),
                    icon: const Icon(Icons.support_agent, size: 18),
                    label: const Text(
                      'Request Repair',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 12.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.cascadeWarning,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
