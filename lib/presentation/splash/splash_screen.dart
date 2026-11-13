import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../data/datasources/local/local_database.dart';
import '../../state/auth_provider.dart';
import '../../state/settings_provider.dart';
import 'widgets/pulse_logo.dart';

/// Splash — brand moment, then routes to onboarding / login / home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final db = context.read<LocalDatabase>();
    // Parallel: session + settings load while the brand animation plays.
    await Future.wait([
      context.read<AuthProvider>().loadSession(),
      context.read<SettingsProvider>().load(),
      Future<void>.delayed(const Duration(milliseconds: 2400)),
    ]);

    if (!mounted) return;
    final bool seenOnboarding = db.readBool(LocalDatabase.kOnboarding);
    final bool signedIn = context.read<AuthProvider>().isSignedIn;

    Navigator.pushReplacementNamed(
      context,
      !seenOnboarding
          ? AppRoutes.onboarding
          : (signedIn ? AppRoutes.home : AppRoutes.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF12110E),
              Color(0xFF241F14),
              Color(0xFF12110E),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Warm glow behind the logo.
            Positioned(
              top: -140,
              right: -110,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF7E2D).withOpacity(0.28),
                      const Color(0xFFFF7E2D).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  const PulseLogo(size: 110),
                  const SizedBox(height: 26),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFC65C).withOpacity(0.95),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(flex: 2),
                  const LoadingDotsRow(),
                  const Spacer(flex: 2),
                  const Text(
                    'Har plate ki hifazat, ab aapki jeb mein',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Team badge — Developed by Panel Care Team 7-H
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFFFC65C).withOpacity(0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.solar_power,
                            size: 15, color: Color(0xFFFFC65C)),
                        const SizedBox(width: 7),
                        const Text(
                          AppConstants.developerCredit,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wraps the loading dots with a fixed color.
class LoadingDotsRow extends StatelessWidget {
  const LoadingDotsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(),
        SizedBox(width: 8),
        _Dot(delay: true),
        SizedBox(width: 8),
        _Dot(),
      ],
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({this.delay = false});
  final bool delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay
        ? const Duration(milliseconds: 180)
        : Duration.zero)
        .then((_) => mounted ? _c.repeat(reverse: true) : null);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.25, end: 1).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 9,
        height: 9,
        decoration: const BoxDecoration(
          color: Color(0xFFF7A021),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
