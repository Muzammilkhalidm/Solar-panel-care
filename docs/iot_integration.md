# IoT Integration Guide — from Simulator to Real Hardware

**Developed by Panel Care Team 7-H**

## Current (Simulator) Wiring

```
AppProviders.build()
    └── IotDeviceDatasource iot = SimulatedIotDatasource()
        └── used by IotSimulationEngine + DiagnosticsRepositoryImpl
```

`SimulatedIotDatasource` models real physics so the demo behaves like
hardware:

- Solar irradiance curve `sin(pi*(hour-6)/13)` × per-device cloud random-walk
- Cell temperature = ambient + 34×sun ± noise
- Power = rated × sun × 0.97 × (1 − 0.0038×(Tcell−25))  ← temperature derating
- Fault effects: hotspot (+20 °C, −16 %), soiling (−40 %), shading (−55 %),
  open circuit (0 A, V→Voc), string failure (−67 %)…

## Real Hub (ESP32) — One Class to Replace

Per-plate sensing kit (cheap & available in Pakistan):

| Part | Role |
| --- | --- |
| INA219 / INA226 | Bus voltage + shunt current per plate |
| DS18B20 | Plate back-surface temperature |
| LDR or BH1750 | Irradiance reference |
| Relay / MOSFET | Per-plate disconnect (remote OFF) |
| ESP32 (Wi-Fi) | Reads sensors, serves REST/MQTT |

### REST contract already coded in `MqttIotDatasource`

```
GET  {hub}/health                    → 200 OK
GET  {hub}/api/v1/panels/{deviceId}
     → {"voltage":40.2,"current":9.8,"power":394.0,
        "temperature":48.5,"irradiance":910.0,
        "efficiency":93.2,"fault":"none"}
POST {hub}/api/v1/panels/command     → deviceId, on(0|1)
POST {hub}/api/v1/diagnostics        → deviceId
```

### Swap

```dart
// app_providers.dart
final IotDeviceDatasource iot = MqttIotDatasource();   // instead of Simulated…
// + set AppEndpoints.iotHubBaseUrl to your hub's LAN address
```

Nothing else in the app changes — domain, services and UI are transport-agnostic
by design.

## Firmware Sketch (pseudo)

```cpp
for each plate:
  v  = ina219.getBusVoltage();
  i  = ina219.getCurrent() * shuntFactor;
  t  = ds18b20.read();
  w  = lux * panelArea * 0.0004;   // W/m² estimate
  p  = v * i;
  e  = p / (rated * (w/1000) * 0.95) * 100;
  fault = hotspotRule(t) || openCircuitRule(i, w) || soilingRule(e);
  serve JSON; relay = stateCommanded;
```

## Alert Thresholds (defaults, editable in-app)

- Temperature: **75 °C** (Settings slider 50–95)
- Performance: **55 %** (Settings slider 25–85)
- Connection: device silent for 1 tick = offline alert
- Critical faults → alarm + optional auto-shutdown
