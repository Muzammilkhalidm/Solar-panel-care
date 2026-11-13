import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/ui_helpers.dart';
import '../../data/datasources/local/local_database.dart';
import 'widgets/dots_indicator.dart';
import 'widgets/onboarding_page_content.dart';
import 'package:provider/provider.dart';
import 'widgets/onboarding_data.dart';

/// 3-slide onboarding with real-life solar photos.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<OnboardingData> _pages = [
    OnboardingData(
      image: AppAssets.imgSolarFarm,
      title: AppStrings.monitorEveryPanel,
      description: AppStrings.monitorEveryPanelDesc,
    ),
    OnboardingData(
      image: AppAssets.imgDamaged,
      title: AppStrings.instantFaultAlerts,
      description: AppStrings.instantFaultAlertsDesc,
    ),
    OnboardingData(
      image: AppAssets.imgInverter,
      title: AppStrings.totalRemoteControl,
      description: AppStrings.totalRemoteControlDesc,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final db = context.read<LocalDatabase>();
    await db.writeBool(LocalDatabase.kOnboarding, true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final bool isLast = _page == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) =>
                    OnboardingPageContent(data: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DotsIndicator(
                    count: _pages.length,
                    index: _page,
                    activeColor: p.brandPrimary,
                    inactiveColor: p.cardBorder,
                  ),
                  Row(
                    children: [
                      if (!isLast)
                        OutlinedButton(
                          onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOut,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(52, 52),
                            side: BorderSide(color: p.cardBorder),
                            shape: const CircleBorder(),
                          ),
                          child: Icon(Icons.arrow_forward,
                              size: 22, color: p.textPrimary),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _finish,
                          icon: const Icon(Icons.solar_power, size: 20),
                          label: const Text('Get Started'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7A021),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(150, 52),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
