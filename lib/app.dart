import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/app_globals.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'presentation/alerts/alert_detail_screen.dart';
import 'presentation/analytics/analytics_screen.dart';
import 'presentation/auth/forgot_password_screen.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/register_screen.dart';
import 'presentation/layout/main_shell.dart';
import 'presentation/panels/add_panel_screen.dart';
import 'presentation/panels/panel_detail_screen.dart';
import 'presentation/settings/about_screen.dart';
import 'presentation/settings/profile_screen.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/splash/splash_screen.dart';

/// Root widget: themes (dark + light) + named routes.
class SolarCareApp extends StatelessWidget {
  const SolarCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: theme.mode,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(
                builder: (_) => const SplashScreen());
          case AppRoutes.onboarding:
            return MaterialPageRoute(
                builder: (_) => const OnboardingScreen());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case AppRoutes.register:
            return MaterialPageRoute(
                builder: (_) => const RegisterScreen());
          case AppRoutes.forgotPassword:
            return MaterialPageRoute(
                builder: (_) => const ForgotPasswordScreen());
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const MainShell());
          case AppRoutes.panelDetail:
            final String panelId = settings.arguments as String? ?? '';
            return MaterialPageRoute(
                builder: (_) => PanelDetailScreen(panelId: panelId));
          case AppRoutes.addPanel:
            return MaterialPageRoute(
                builder: (_) => const AddPanelScreen());
          case AppRoutes.alertDetail:
            final String alertId = settings.arguments as String? ?? '';
            return MaterialPageRoute(
                builder: (_) => AlertDetailScreen(alertId: alertId));
          case AppRoutes.analytics:
            return MaterialPageRoute(
                builder: (_) => const AnalyticsScreen());
          case AppRoutes.profile:
            return MaterialPageRoute(
                builder: (_) => const ProfileScreen());
          case AppRoutes.about:
            return MaterialPageRoute(builder: (_) => const AboutScreen());
          default:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );
        }
      },
    );
  }
}
