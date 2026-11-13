# Features & Demo Script — Solar Panel Care

**Developed by Panel Care Team 7-H**

## Feature Checklist

### 1. IoT Monitoring (per plate)
- [x] Device id per plate (`IOT-xxxxxx`), connect/disconnect/reconnect
- [x] Readings: voltage, current, power, temperature, irradiance, efficiency
- [x] 4-second heartbeat; live charts on dashboard + plate detail
- [x] Online / offline / fault / maintenance / powered-off states

### 2. Damage Alerts & Alarm
- [x] 11 fault types (hotspot, open circuit, soiling, shading, micro crack,
      bypass diode, inverter, over-temp, under-performance, connection loss,
      string failure)
- [x] Physics-inspired symptoms (temperature spike, output drop, zero current)
- [x] Severity scale (info → critical) with colors
- [x] **Looping alarm siren + heavy vibration + red emergency banner**
- [x] Cascade warning: "one damaged plate can drag the whole array down"
- [x] Auto-shutdown of critically damaged plate (toggleable)

### 3. Remote Control
- [x] Master system switch (all plates)
- [x] Individual plate switches with live wattage
- [x] Emergency shutdown with confirmation
- [x] Maintenance mode toggle per plate

### 4. Care & Repair
- [x] Alert detail with "readings at alert time" snapshot
- [x] Recommendation per fault type (clean / trim shade / replace diode…)
- [x] Request Technician → maintenance record (scheduled)
- [x] Mark Repaired → fault cleared + repair logged + health restored
- [x] Guided 7-point diagnostics with full report sheet
- [x] Maintenance log per plate

### 5. Insights
- [x] Today / week / lifetime kWh, PKR savings, CO₂ kg, tree-years
- [x] 7-day bar chart, efficiency trend, per-plate comparison
- [x] Live weather banner (Open-Meteo + offline fallback)

### 6. App Experience
- [x] Splash (animated sun) + photo onboarding
- [x] Local auth (register / login / demo account / forgot password)
- [x] Search + filters on plates list; add / remove plates
- [x] **Dark + Light themes** (system/light/dark + quick toggle)
- [x] Demo tools: Simulate Damage, Demo Sun, hub disconnect, factory reset
- [x] "Developed by Panel Care Team 7-H" on splash, login, settings, about, README

## 5-Minute Demo Script

| Step | Do | Expect |
| --- | --- | --- |
| 1 | Run app | Splash → onboarding (3 real photos) → login |
| 2 | Login `demo@solarcare.pk` / `solar123` | Dashboard, hub connected, plates producing |
| 3 | Tap a plate card | Detail: readings grid + live chart + health ring |
| 4 | Back → dashboard → **Simulate Damage** | Alert fires, **alarm rings**, red banner on top |
| 5 | Banner → STOP ALARM → open alert | Fault description + snapshot + recommendation |
| 6 | Request Technician | Maintenance record created (check plate detail log) |
| 7 | Mark Repaired on the plate | Fault cleared, health restored, log entry added |
| 8 | Control tab | Turn master OFF → all plates "Powered Off" → ON again |
| 9 | Analytics tab | Savings + 7-day energy + per-plate comparison |
| 10 | Settings → Dark mode | Whole app switches instantly; About → developer card |

## Viva Q&A Quick Answers

**Q: Real device kaise jurega?**
A: `MqttIotDatasource` same interface implement karta hai — ESP32 hub ko
replace karne ke liye sirf provider wiring badalni hai
(docs/iot_integration.md).

**Q: Ek plate kharab ho to baqi kyun khatray me hain?**
A: Series string me ek under-performing plate poori string ka current limit
kar deti hai (aur hotspot aag ka risk hai) — isi liye app foran batati hai.

**Q: Data kahan save hota hai?**
A: SharedPreferences JSON (offline-first). Firebase/SQL me shift karna ho to
sirf datasource badlega, domain/baaki app untouched.
