# ☀️ Solar Panel Care — Advanced IoT Solar Monitoring (Flutter)

> **Har solar plate ki hifazat — ab aapki jeb mein.**
> A complete Flutter/Dart project where every solar plate is connected to the
> app through an IoT device. Individual live readings per plate, instant
> alarm when a plate gets damaged, and full remote ON/OFF control from the
> mobile app — **Developed by Panel Care Team 7-H**.

---

## 🎯 The Problem It Solves

Pehle log solar panels lagwate the lekin **pata nahi chalta tha ke kaunsi
plate kharab ho gayi hai**. Poori string ki output gir jati thi aur engineer
ko bulana parta tha — bara time aur kharcha.

**Solar Panel Care** is problem ka solution hai:

1. Har solar plate ke sath ek **IoT device** judta hai (simulated in this
   build; real-hub transport file included).
2. App **har plate ki individual reading** leti hai — voltage, current,
   power, temperature, irradiance, efficiency — har 4 seconds.
3. Koi plate kharab ho (hotspot, micro crack, soiling, open circuit…) to app
   **loud alarm + vibration + red banner** ke sath batati hai ke *kaunsi*
   plate kharab hai aur *kyun* — taake baqi plates bhi kharab hone se pehle
   bacha li jayen.
4. Customer khud plate **OFF/ON** kar sakta hai, diagnostics chala sakta hai,
   aur technician request book kar sakta hai.

---

## ✨ Features

| Area | What you get |
| --- | --- |
| **Live Monitoring** | Per-plate readings every 4s, system totals, live charts |
| **Fault Detection** | 11 fault types with physics-inspired symptoms (hotspot raises temperature, soiling cuts output…) |
| **Emergency Alarm** | Looping siren (`alarm.wav`) + vibration + red emergency banner + auto-shutdown option |
| **Remote Control** | Master system switch, per-plate switches, emergency shutdown, maintenance mode |
| **Diagnostics** | 7-point guided test per plate with full report sheet |
| **Maintenance Log** | Cleaning / repair / replacement records per plate |
| **Analytics** | 7-day energy bars, efficiency trend, per-plate comparison, PKR savings, CO₂ & tree-years |
| **Weather** | Live Open-Meteo weather with offline simulated fallback |
| **Themes** | Complete **dark + light** themes (system/light/dark selector + quick toggle) |
| **Auth** | Local register/login, demo account, session persistence |
| **Demo Tools** | "Simulate Damage" button, Demo Sun toggle, hub disconnect simulation, factory reset |

## 🖼️ Real-life Photos

The app ships with **10 real solar photos** (solar farms, rooftop installs,
cleaning, damaged plate, inverter, inspection…) used across onboarding,
dashboard, panels, alerts and about screens — see `assets/images/`.

---

## 🚀 Run It (2 minutes)

```bash
# 1. Install Flutter (3.19+ recommended): https://docs.flutter.dev/get-started/install

# 2. WEB — instantly runnable (web/ folder already included):
flutter pub get
flutter run -d chrome

# 3. ANDROID / iOS — generate the platform folder first:
flutter create . --platforms=android,ios --org com.panelcare --project-name solar_panel_care
flutter pub get
flutter run
```

**Demo login:** `demo@solarcare.pk` / `solar123` (ya apna account register karein)

> **Tip:** Settings me **Demo Sun** ON hota hai — raat ko bhi plates produce
> karti hain taake demo zinda rahe. Dashboard ke **Simulate Damage** button
> se fault + alarm flow foran test karein.

---

## 🗂️ Architecture (Clean-ish, 100+ files)

```
lib/
├── main.dart / app.dart          # composition root + routes + themes
├── core/                          # constants, theme (light+dark palettes),
│   │                              # utils, 13 reusable widgets
│   ├── constants/  theme/  utils/  widgets/
├── domain/
│   ├── entities/    (Panel, PanelReading, Alert, FaultType, …)
│   ├── repositories (abstract contracts)
│   └── usecases/    (GetPanels, TogglePanelPower, RequestRepair, …)
├── data/
│   ├── models/      (JSON-mappable variants of every entity)
│   ├── datasources/
│   │   ├── local/   (SharedPreferences wrapper, seed service)
│   │   └── remote/  (IotDeviceDatasource: simulator + real-hub skeleton)
│   └── repositories/ (implementations)
├── services/        # IoT simulation engine, alert engine, alarm, haptics,
│                    # notifications
├── state/           # provider wiring + ChangeNotifiers per feature
└── presentation/    # splash, onboarding, auth, dashboard, panels,
                     # alerts, control, analytics, settings, common
docs/
├── architecture.md  # full layer diagram + data flow
├── features.md      # feature-by-feature walkthrough (demo script)
└── iot_integration.md  # how to swap the simulator for a real ESP32 hub
```

**IoT heartbeat** (`IotSimulationEngine`): every 4 s → read each plate →
update live values & energy → evaluate thresholds/faults → fire alerts &
alarm → record system snapshot → persist every 10 ticks.

---

## 🔌 Real Hardware

`lib/data/datasources/remote/mqtt_iot_datasource.dart` is a documented,
compiling skeleton for a real hub (ESP32 + INA226 per plate + DS18B20 +
relay). See `docs/iot_integration.md` for the exact JSON contract and wiring
plan.

---

## 📱 Demo Script (viva / presentation)

1. **Splash + onboarding** (real photos) → login `demo@solarcare.pk/solar123`.
2. **Dashboard**: premium dark hero card (photo + output + eco chips),
   today's energy gauge, system insights, live readings, weather.
3. **Panels tab**: 8 plates with photos, search + filters → open a plate
   (readings grid + live chart + diagnostics).
4. Press **⚡ Simulate Damage** on the dashboard → within a second the plate
   goes red, **alarm rings**, banner appears — *yehi asal feature hai*.
5. **Stop Alarm → Mark Repaired** ya **Request Technician** (maintenance log
   me entry aa jati hai).
6. **Control tab**: master switch, per-plate switches, emergency shutdown.
7. **Analytics**: 7-day kWh, efficiency, PKR savings, CO2.
8. **Settings**: dark/light switch, Demo Sun, alarm test, thresholds,
   factory reset. About screen par **Developed by Panel Care Team 7-H**.

---

## 🧰 Troubleshooting

| Symptom | Fix |
| --- | --- |
| `flutter create` se pehle `pub get` fail | Pehle `flutter create .` chalayen (platform folders banti hain) |
| Alarm silent on emulator | Android emulator audio enable karein ya real device use karein |
| Vibration not working | Real device par test karein (emulator vibrator support nahi karta) |
| Weather "Simulated" | Offline hai — app automatically fallback use karti hai, koi crash nahi |
| Production 0 W at night | Settings → **Demo Sun** ON karein |

---

## 👨‍💻 Credits

**Developed by Panel Care Team 7-H** — Solar Panel Care v2.0.0
Flutter • Dart • IoT simulation • Premium cream/charcoal theme • Real-life imagery

*Made with ☀️ and Flutter.*
