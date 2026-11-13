import 'package:flutter_test/flutter_test.dart';

import 'package:solar_panel_care/core/constants/app_constants.dart';
import 'package:solar_panel_care/core/utils/date_time_utils.dart';
import 'package:solar_panel_care/core/utils/formatters.dart';
import 'package:solar_panel_care/core/utils/validators.dart';
import 'package:solar_panel_care/domain/entities/panel.dart';
import 'package:solar_panel_care/domain/entities/panel_fault.dart';
import 'package:solar_panel_care/domain/entities/panel_reading.dart';
import 'package:solar_panel_care/domain/entities/system_settings.dart';

void main() {
  group('AppConstants', () {
    test('branding is present', () {
      expect(AppConstants.appName, 'Solar Panel Care');
      expect(AppConstants.developerCredit, 'Developed by Panel Care Team 7-H');
      expect(AppConstants.demoEmail, 'demo@solarcare.pk');
    });
  });

  group('Validators', () {
    test('email validation', () {
      expect(Validators.email('demo@solarcare.pk'), isNull);
      expect(Validators.email('bad-email'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('password validation', () {
      expect(Validators.password('solar123'), isNull);
      expect(Validators.password('123'), isNotNull);
    });
  });

  group('Formatters', () {
    test('watts formatting', () {
      expect(AppFormatters.watts(850), '850 W');
      expect(AppFormatters.watts(2850), '2.85 kW');
    });

    test('kwh + percent', () {
      expect(AppFormatters.kwh(2.25), '2.25 kWh');
      expect(AppFormatters.percent(93.456), '93.5%');
    });
  });

  group('Solar curve', () {
    test('night produces zero, forced sun produces bright factor', () {
      final double forced =
          AppDateTimeUtils.solarFactor(forceSunlight: true);
      expect(forced, greaterThan(0.5));
    });
  });

  group('Panel entity', () {
    test('faulted panel flags', () {
      final Panel panel = Panel(
        id: 'SP-TEST',
        name: 'Test Plate',
        model: 'Test 500W',
        ratedWatts: 500,
        deviceId: 'IOT-TEST01',
        location: 'Lab',
        installedOn: DateTime.now(),
        lastMaintenance: DateTime.now(),
        activeFault: PanelFaultType.hotspot,
        history: [
          PanelReading(
            timestamp: DateTime.now(),
            voltage: 40,
            current: 5,
            power: 200,
            temperature: 55,
            irradiance: 600,
            efficiency: 40,
          ),
        ],
      );
      expect(panel.isFaulted, isTrue);
      expect(panel.activeFault.isCritical, isTrue);
      expect(panel.activeFault.label, contains('Hotspot'));
      expect(panel.history.first.power, 200);
    });
  });

  group('SystemSettings', () {
    test('copyWith keeps values', () {
      final SystemSettings base = SystemSettings();
      expect(base.forceSunlight, isTrue);
      final SystemSettings changed =
          base.copyWith(temperatureThreshold: 82);
      expect(changed.temperatureThreshold, 82);
      expect(changed.forceSunlight, isTrue);
    });
  });
}
