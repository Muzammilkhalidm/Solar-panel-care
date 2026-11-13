import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/ui_helpers.dart';
import '../../domain/entities/alert.dart';
import '../../state/alerts_provider.dart';
import '../alerts/alerts_screen.dart' show openAlertDetail;

/// Red emergency banner shown over the shell while a critical alert is
/// active or the alarm is ringing. Provides "Stop Alarm" + jump to alert.
class AlarmBanner extends StatefulWidget {
  const AlarmBanner({super.key, this.alert});

  final Alert? alert;

  @override
  State<AlarmBanner> createState() => _AlarmBannerState();
}

class _AlarmBannerState extends State<AlarmBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<AlertsProvider>();
    final Alert? alert = widget.alert;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.82, end: 1.0).animate(_c),
        child: Material(
          color: const Color(0xFFE5484D),
          elevation: 8,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  const Icon(Icons.campaign, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert?.title ??
                              'CRITICAL ALERT — plate damaged!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          alert?.message ?? AppConstants.cascadeWarning,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: 11.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => alerts.stopAlarm(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFE5484D),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 34),
                    ),
                    child: const Text('STOP ALARM',
                        style: TextStyle(
                            fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 6),
                  if (alert != null)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => openAlertDetail(context, alert),
                      icon: const Icon(Icons.open_in_new,
                          color: Colors.white, size: 20),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
