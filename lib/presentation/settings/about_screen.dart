import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/ui_helpers.dart';
import '../common/image_banner.dart';
import '../../core/constants/app_assets.dart';

/// About screen with app info, features, tech stack and the developer card.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<(IconData, String, String)> _features = [
    (
      Icons.solar_power,
      'Per-Plate IoT Monitoring',
      'Har solar plate ka apna IoT device voltage, current, power, '
          'temperature aur irradiance live bhejta hai.'
    ),
    (
      Icons.campaign,
      'Damage Alerts + Alarm',
      'Koi plate kharab ho to app foran alarm bajati hai aur batati hai ke '
          'kaunsi plate theek karwani hai — pehle poora array kharab hone se.'
    ),
    (
      Icons.power_settings_new,
      'Remote ON/OFF',
      'Mobile se koi bhi plate ya poora system ON/OFF karein — kahin se bhi.'
    ),
    (
      Icons.monitor_heart,
      'Guided Diagnostics',
      '7-point electrical test har plate par — report ke sath recommendation.'
    ),
    (
      Icons.savings,
      'Savings & CO2',
      'Aaj kitni bijli bachi, kitne paise bache — sab hisaab kitab app mein.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
        children: [
          ImageBanner(
            asset: AppAssets.imgTechnician,
            height: 150,
            borderRadius: 20,
            children: [
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'v${AppConstants.appVersion} (build ${AppConstants.buildNumber})',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Problem jo yeh app solve karti hai',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Pehle log solar panels lagwate the lekin unhe pata nahi chalta '
            'tha ke kaunsi plate kharab ho gayi hai. Poori string ki output '
            'girti rehti thi aur engineer ko bulana parta tha — jo time bhi '
            'leta tha aur paise bhi. Solar Panel Care har plate ko IoT device '
            'se jor kar is problem ko khatam karta hai: har plate ki reading '
            'alag se mobile par, aur kharabi ke foran baad alarm.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ..._features.map(
            (f) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: p.cardBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7A021).withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(f.$1,
                        size: 19, color: const Color(0xFFFF7E2D)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.$2,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: p.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          f.$3,
                          style: TextStyle(
                            fontSize: 11.5,
                            height: 1.4,
                            color: p.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tech Stack',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Flutter 3.x', 'Dart 3', 'Provider', 'fl_chart',
              'SharedPreferences', 'audioplayers', 'vibration', 'http',
              'Clean Architecture', 'IoT Simulation Engine',
            ]
                .map(
                  (chip) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: p.surfaceAlt,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: p.cardBorder),
                    ),
                    child: Text(
                      chip,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: p.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 26),
          // Developer card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2721), Color(0xFF1D1B17)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33241C08),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppColors.energyGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.groups_2,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  AppConstants.developerCredit,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.developerRole,
                  style: TextStyle(
                    color: const Color(0xFFFFC65C).withOpacity(0.95),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '"Solar energy ko smart banaya jaye — har plate apni '
                  'khabar khud de."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${AppConstants.appName} • ${AppConstants.appVersion} • '
              'Made with Flutter',
              style: TextStyle(fontSize: 10.5, color: p.textFaint),
            ),
          ),
        ],
      ),
    );
  }
}
