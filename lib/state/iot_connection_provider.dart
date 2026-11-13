import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/datasources/remote/iot_device_datasource.dart';
import '../services/iot_simulation_engine.dart';

/// Mirrors the link state between the app and the IoT hub.
enum IotLinkState { connecting, connected, offline }

class IotConnectionProvider extends ChangeNotifier {
  IotConnectionProvider({
    required IotDeviceDatasource iot,
    required IotSimulationEngine engine,
  })  : _iot = iot,
        _engine = engine;

  final IotDeviceDatasource _iot;
  final IotSimulationEngine _engine;

  IotLinkState state = IotLinkState.connecting;
  int ticks = 0;
  DateTime? lastTickAt;
  StreamSubscription<int>? _sub;

  bool get isConnected => state == IotLinkState.connected;

  String get stateLabel {
    switch (state) {
      case IotLinkState.connecting:
        return 'Connecting…';
      case IotLinkState.connected:
        return 'IoT Hub Connected';
      case IotLinkState.offline:
        return 'Hub Offline';
    }
  }

  Future<void> connect() async {
    state = IotLinkState.connecting;
    notifyListeners();

    await _iot.connect();
    // Small realistic handshake delay.
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    state = _iot.isConnected ? IotLinkState.connected : IotLinkState.offline;
    notifyListeners();

    _sub ??= _engine.tickStream.listen((t) {
      ticks = t;
      lastTickAt = DateTime.now();
      notifyListeners();
    });
  }

  /// Demo action from settings: pretend the hub went down.
  Future<void> simulateDisconnect() async {
    await _iot.disconnect();
    state = IotLinkState.offline;
    notifyListeners();
  }

  Future<void> reconnect() => connect();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
