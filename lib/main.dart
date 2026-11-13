import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/app_globals.dart';
import 'state/app_providers.dart';
import 'app.dart';

/// Solar Panel Care — Advanced IoT Solar Monitoring.
///
/// Developed by Panel Care Team 7-H.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: AppProviders(prefs).build(),
      child: const SolarCareApp(),
    ),
  );
}

/// Kept public so integration tests can pump the real app.
@visibleForTesting
String get appTitle => AppConstants.appName;

// appNavigatorKey lives in core/constants/app_globals.dart and is picked up
// by NotificationService for global banners.
