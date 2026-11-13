import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/theme_controller.dart';
import '../data/datasources/local/alert_local_datasource.dart';
import '../data/datasources/local/local_database.dart';
import '../data/datasources/local/panel_local_datasource.dart';
import '../data/datasources/local/seed_data_service.dart';
import '../data/datasources/local/user_local_datasource.dart';
import '../data/datasources/remote/iot_device_datasource.dart';
import '../data/datasources/remote/simulated_iot_datasource.dart';
import '../data/repositories/alert_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/diagnostics_repository_impl.dart';
import '../data/repositories/panel_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../data/repositories/stats_repository_impl.dart';
import '../domain/usecases/add_panel.dart';
import '../domain/usecases/get_alerts.dart';
import '../domain/usecases/get_energy_stats.dart';
import '../domain/usecases/get_panels.dart';
import '../domain/usecases/remove_panel.dart';
import '../domain/usecases/request_repair.dart';
import '../domain/usecases/resolve_alert.dart';
import '../domain/usecases/run_panel_diagnostics.dart';
import '../domain/usecases/sign_in.dart';
import '../domain/usecases/sign_out.dart';
import '../domain/usecases/sign_up.dart';
import '../domain/usecases/toggle_panel_power.dart';
import '../domain/usecases/toggle_system_power.dart';
import '../services/alarm_player_service.dart';
import '../services/alert_engine.dart';
import '../services/haptic_service.dart';
import '../services/iot_simulation_engine.dart';
import 'alerts_provider.dart';
import 'auth_provider.dart';
import 'iot_connection_provider.dart';
import 'panels_provider.dart';
import 'settings_provider.dart';
import 'stats_provider.dart';

/// Composition root: builds and wires every dependency of the app.
class AppProviders {
  AppProviders(this.prefs);

  final SharedPreferences prefs;

  List<SingleChildWidget> build() {
    // ---- Infrastructure ----
    final LocalDatabase db = LocalDatabase(prefs);
    final PanelLocalDatasource panelLocal = PanelLocalDatasource(db);
    final AlertLocalDatasource alertLocal = AlertLocalDatasource(db);
    final UserLocalDatasource userLocal = UserLocalDatasource(db);
    final SeedDataService seed = SeedDataService();

    final IotDeviceDatasource iot = SimulatedIotDatasource();

    // ---- Repositories ----
    final PanelRepositoryImpl panelRepo = PanelRepositoryImpl(panelLocal, seed);
    final AlertRepositoryImpl alertRepo = AlertRepositoryImpl(alertLocal);
    final AuthRepositoryImpl authRepo = AuthRepositoryImpl(userLocal, db);
    final SettingsRepositoryImpl settingsRepo = SettingsRepositoryImpl(db);
    final StatsRepositoryImpl statsRepo = StatsRepositoryImpl(db, panelRepo);
    final DiagnosticsRepositoryImpl diagnosticsRepo =
        DiagnosticsRepositoryImpl(iot);
    final RunPanelDiagnostics runDiagnostics =
        RunPanelDiagnostics(diagnosticsRepo);

    // ---- Device services ----
    final AlarmPlayerService alarmPlayer = AlarmPlayerService();
    final HapticService haptics = HapticService();

    // ---- Engines ----
    final AlertEngine alertEngine = AlertEngine(
      alertRepository: alertRepo,
      alarmPlayer: alarmPlayer,
      haptics: haptics,
    );
    final IotSimulationEngine engine = IotSimulationEngine(
      panelRepository: panelRepo,
      statsRepository: statsRepo,
      settingsRepository: settingsRepo,
      alertEngine: alertEngine,
      iot: iot,
    );

    // ---- Use cases ----
    final GetPanels getPanels = GetPanels(panelRepo);
    final TogglePanelPower togglePanelPower = TogglePanelPower(panelRepo);
    final ToggleSystemPower toggleSystemPower = ToggleSystemPower(panelRepo);
    final AddPanel addPanel = AddPanel(panelRepo);
    final RemovePanel removePanel = RemovePanel(panelRepo);
    final GetAlerts getAlerts = GetAlerts(alertRepo);
    final ResolveAlert resolveAlert = ResolveAlert(alertRepo);
    final RequestRepair requestRepair = RequestRepair(panelRepo, alertRepo);
    final SignIn signIn = SignIn(authRepo);
    final SignUp signUp = SignUp(authRepo);
    final SignOut signOut = SignOut(authRepo);
    final GetEnergyStats getEnergyStats = GetEnergyStats(statsRepo);

    // ---- ChangeNotifiers / providers ----
    return [
      Provider<LocalDatabase>.value(value: db),
      Provider<IotDeviceDatasource>.value(value: iot),
      Provider<RunPanelDiagnostics>.value(value: runDiagnostics),
      Provider<AlarmPlayerService>.value(value: alarmPlayer),
      Provider<HapticService>.value(value: haptics),
      Provider<IotSimulationEngine>.value(value: engine),

      ChangeNotifierProvider<ThemeController>(
        create: (_) => ThemeController(prefs)..load(),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(
          signIn: signIn,
          signUp: signUp,
          signOut: signOut,
          repository: authRepo,
        ),
      ),
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(
          repository: settingsRepo,
          alarmPlayer: alarmPlayer,
          haptics: haptics,
        ),
      ),
      ChangeNotifierProvider<PanelsProvider>(
        create: (_) => PanelsProvider(
          getPanels: getPanels,
          togglePanelPower: togglePanelPower,
          toggleSystemPower: toggleSystemPower,
          addPanel: addPanel,
          removePanel: removePanel,
          repository: panelRepo,
          iot: iot,
        ),
      ),
      ChangeNotifierProvider<AlertsProvider>(
        create: (_) => AlertsProvider(
          getAlerts: getAlerts,
          resolveAlert: resolveAlert,
          requestRepair: requestRepair,
          repository: alertRepo,
          alarmPlayer: alarmPlayer,
          haptics: haptics,
        ),
      ),
      ChangeNotifierProvider<StatsProvider>(
        create: (_) => StatsProvider(
          getEnergyStats: getEnergyStats,
          repository: statsRepo,
        ),
      ),
      ChangeNotifierProvider<IotConnectionProvider>(
        create: (_) => IotConnectionProvider(iot: iot, engine: engine),
      ),
    ];
  }
}
