import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';
import '../domain/entities/alert.dart';
import '../domain/entities/panel.dart';
import '../domain/entities/panel_fault.dart';
import '../domain/entities/system_settings.dart';
import '../domain/repositories/alert_repository.dart';
import 'alarm_player_service.dart';
import 'haptic_service.dart';
import 'notification_service.dart';

/// Turns a fresh panel reading into alerts:
///  * active IoT fault  -> fault alert (+ alarm for high/critical)
///  * over-temperature  -> temperature alert
///  * low efficiency    -> performance alert
///  * offline device    -> connection alert
/// Each alert type is de-duplicated per panel while unresolved.
class AlertEngine {
  AlertEngine({
    required AlertRepository alertRepository,
    required this.alarmPlayer,
    required this.haptics,
  }) : _alertRepository = alertRepository;

  final AlertRepository _alertRepository;
  final AlarmPlayerService alarmPlayer;
  final HapticService haptics;

  Future<void> evaluatePanel(Panel panel, SystemSettings settings) async {
    final List<Alert> candidates = [];

    if (panel.activeFault.isActive) {
      candidates.add(_buildFaultAlert(panel));
    }
    if (panel.temperature > settings.temperatureThreshold) {
      candidates.add(_buildTemperatureAlert(panel, settings));
    } else if (panel.efficiency > 0 &&
        panel.efficiency < settings.performanceThreshold &&
        panel.irradiance > 120) {
      candidates.add(_buildPerformanceAlert(panel, settings));
    }
    if (panel.status == PanelStatus.offline) {
      candidates.add(_buildConnectionAlert(panel));
    }

    for (final Alert alert in candidates) {
      final bool duplicate = await _alertRepository.hasUnresolvedOfType(
        alert.panelId,
        alert.type,
        faultType: alert.faultType,
      );
      if (duplicate) continue;

      await _alertRepository.addAlert(alert);
      AppLogger.i('AlertEngine',
          'Alert ${alert.severity.name} -> ${alert.panelName}: ${alert.title}');

      final bool loud = alert.severity == AlertSeverity.critical ||
          alert.severity == AlertSeverity.high;
      if (loud) {
        if (settings.alarmSoundEnabled) {
          await alarmPlayer.startAlarm();
        }
        if (settings.vibrationEnabled) {
          await haptics.alertPattern(
              critical: alert.severity == AlertSeverity.critical);
        }
      }
      if (loud || alert.severity == AlertSeverity.medium) {
        NotificationService.instance.show(
          title: alert.title,
          body: alert.message,
          colorValue: _colorFor(alert.severity),
        );
      }
    }
  }

  Alert _buildFaultAlert(Panel panel) {
    final PanelFaultType fault = panel.activeFault;
    return Alert(
      id: _nextId(),
      panelId: panel.id,
      panelName: panel.name,
      title: '${fault.label} — ${panel.name}',
      message:
          '${fault.description} ${fault.isCritical ? AppConstants.cascadeWarning : ""}',
      severity: _severityForFault(fault),
      type: AlertType.fault,
      faultType: fault,
      createdAt: DateTime.now(),
      snapshot: _snapshot(panel),
    );
  }

  Alert _buildTemperatureAlert(Panel panel, SystemSettings settings) {
    return Alert(
      id: _nextId(),
      panelId: panel.id,
      panelName: panel.name,
      title: 'Over Temperature — ${panel.name}',
      message:
          'Plate temperature reached ${panel.temperature.toStringAsFixed(1)}°C '
          '(limit ${settings.temperatureThreshold.toStringAsFixed(0)}°C). '
          'Continuous heat ages the cells faster.',
      severity: AlertSeverity.high,
      type: AlertType.temperature,
      createdAt: DateTime.now(),
      snapshot: _snapshot(panel),
    );
  }

  Alert _buildPerformanceAlert(Panel panel, SystemSettings settings) {
    return Alert(
      id: _nextId(),
      panelId: panel.id,
      panelName: panel.name,
      title: 'Low Performance — ${panel.name}',
      message:
          'Efficiency dropped to ${panel.efficiency.toStringAsFixed(1)}% '
          '(limit ${settings.performanceThreshold.toStringAsFixed(0)}%). '
          'Dust, shading or an internal fault may be the cause.',
      severity: AlertSeverity.medium,
      type: AlertType.performance,
      createdAt: DateTime.now(),
      snapshot: _snapshot(panel),
    );
  }

  Alert _buildConnectionAlert(Panel panel) {
    return Alert(
      id: _nextId(),
      panelId: panel.id,
      panelName: panel.name,
      title: 'IoT Connection Lost — ${panel.name}',
      message:
          'Device ${panel.deviceId} stopped responding. This plate cannot be '
          'monitored until the link is restored.',
      severity: AlertSeverity.medium,
      type: AlertType.connection,
      faultType: PanelFaultType.connectionLoss,
      createdAt: DateTime.now(),
      snapshot: _snapshot(panel),
    );
  }

  Map<String, dynamic> _snapshot(Panel panel) => {
        'power': panel.power,
        'voltage': panel.voltage,
        'current': panel.current,
        'temperature': panel.temperature,
        'irradiance': panel.irradiance,
        'efficiency': panel.efficiency,
        'health': panel.healthScore,
      };

  AlertSeverity _severityForFault(PanelFaultType fault) {
    if (fault.isCritical) return AlertSeverity.critical;
    switch (fault) {
      case PanelFaultType.overTemperature:
      case PanelFaultType.stringFailure:
        return AlertSeverity.high;
      case PanelFaultType.soiling:
      case PanelFaultType.partialShading:
      case PanelFaultType.bypassDiodeFailure:
      case PanelFaultType.underPerformance:
        return AlertSeverity.medium;
      case PanelFaultType.connectionLoss:
        return AlertSeverity.medium;
      default:
        return AlertSeverity.low;
    }
  }

  int _colorFor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return 0xFFE5484D;
      case AlertSeverity.high:
        return 0xFFF97316;
      case AlertSeverity.medium:
        return 0xFFF5A524;
      case AlertSeverity.low:
        return 0xFF38BDF8;
      case AlertSeverity.info:
        return 0xFF3B82F6;
    }
  }

  String _nextId() =>
      'ALT-${DateTime.now().millisecondsSinceEpoch}-${_seq++}';
  static int _seq = 0;
}
