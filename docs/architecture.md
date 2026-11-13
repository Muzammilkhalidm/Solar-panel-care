# Architecture — Solar Panel Care

**Developed by Panel Care Team 7-H**

## Layer Map

```
┌────────────────────────────────────────────────────────────┐
│ presentation/                                              │
│  splash • onboarding • auth • layout(main shell)           │
│  dashboard • panels • alerts • control • analytics •        │
│  settings (+ 20 feature widgets)                           │
│         ▲ watch/read                                       │
├────────────────────────────────────────────────────────────┤
│ state/                                                     │
│  PanelsProvider • AlertsProvider • StatsProvider           │
│  SettingsProvider • AuthProvider • IotConnectionProvider   │
│  ThemeController   (all ChangeNotifier via provider)       │
│         ▲ calls use cases / repositories                   │
├────────────────────────────────────────────────────────────┤
│ services/                                                  │
│  IotSimulationEngine (4s heartbeat)                        │
│  AlertEngine (threshold + fault evaluation, alarm trigger) │
│  AlarmPlayerService • HapticService • NotificationService  │
│         ▲ uses                                             │
├────────────────────────────────────────────────────────────┤
│ domain/                                                    │
│  entities/  Panel, PanelReading, PanelFaultType, Alert,    │
│             MaintenanceRecord, DiagnosticReport,           │
│             SystemSettings, EnergyStats, WeatherInfo       │
│  repositories/ (abstract) • usecases/ (14 one-shot cases)  │
│         ▲ implemented by                                   │
├────────────────────────────────────────────────────────────┤
│ data/                                                      │
│  models/ (JSON mapping)                                    │
│  datasources/local  (SharedPreferences + seed)             │
│  datasources/remote (SimulatedIotDatasource, MqttIot…)     │
│  repositories/ (impls: panel, alert, auth, settings,       │
│                  stats, diagnostics)                       │
├────────────────────────────────────────────────────────────┤
│ core/  constants • theme(light+dark palettes) • utils •    │
│        shared widgets • logger                             │
└────────────────────────────────────────────────────────────┘
```

## Data Flow (one tick, every 4 seconds)

1. `IotSimulationEngine.tick()`
2. `SettingsRepository.getSettings()` → thresholds, Demo Sun, auto-shutdown.
3. For each `Panel`:
   - `SimulatedIotDatasource.readPanel()` builds a physically plausible
     reading (solar curve × cloud walk × temperature derating × fault model).
   - Panel live fields updated; energy (kWh) accumulated; history trimmed.
   - `AlertEngine.evaluatePanel()`:
     - active fault → **fault alert** (severity from fault type)
     - temperature > limit → temperature alert
     - efficiency < limit → performance alert
     - device silent → connection alert
     - dedupe: one unresolved alert per (panel, type, fault)
     - high/critical → **alarm loop + vibration + red banner**
   - critical + auto-shutdown → plate powered OFF automatically.
4. `StatsRepository.recordSystemSnapshot()` → dashboard chart data.
5. Every 10 ticks → `PanelRepository.persist()` (SharedPreferences JSON).
6. `tickStream` → providers refresh → UI rebuilds.

## Persistence

| Key | Content |
| --- | --- |
| `panels_v1` | full panel list incl. history + maintenance log |
| `alerts_v1` | latest 120 alerts |
| `users_v1` / `session_v1` | local accounts + session email |
| `settings_v1` | thresholds & toggles |
| `weekly_energy_v1` | last-7-day kWh seed |
| `onboarding_v1` | onboarding seen flag |

## Theme System

`AppPalette` interface → `LightPalette` / `DarkPalette`; `AppTheme` builds
`ThemeData` from either. `ThemeController` persists system/light/dark and the
dashboard AppBar has a one-tap toggle. Every custom widget reads
`context.palette`, so both themes stay perfectly in sync.
