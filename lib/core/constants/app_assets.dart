/// Central asset registry. All real-life photos bundled with the app.
class AppAssets {
  AppAssets._();

  // ---- Real-life photos (assets/images) ----
  static const String imgSolarFarm = 'assets/images/solar_farm.jpg';
  static const String imgRooftop = 'assets/images/rooftop_panels.jpg';
  static const String imgTechnician = 'assets/images/technician.jpg';
  static const String imgCleaning = 'assets/images/panel_cleaning.jpg';
  static const String imgDamaged = 'assets/images/damaged_panel.jpg';
  static const String imgSunset = 'assets/images/solar_sunset.jpg';
  static const String imgCloseup = 'assets/images/panel_closeup.jpg';
  static const String imgInspection = 'assets/images/engineer_inspection.jpg';
  static const String imgControlRoom = 'assets/images/control_monitor.jpg';
  static const String imgInverter = 'assets/images/inverter_station.jpg';

  /// Photos rotated across panel cards so the list feels alive.
  static const List<String> panelPhotos = [
    imgCloseup,
    imgRooftop,
    imgSolarFarm,
    imgSunset,
  ];

  // ---- Sounds ----
  /// Full asset path (for reference/inspection).
  static const String alarmSound = 'assets/sounds/alarm.wav';

  /// audioplayers AssetSource path (without the 'assets/' prefix).
  static const String alarmAssetSource = 'sounds/alarm.wav';

  // ---- Data ----
  static const String seedPanels = 'assets/data/panels_seed.json';
}
