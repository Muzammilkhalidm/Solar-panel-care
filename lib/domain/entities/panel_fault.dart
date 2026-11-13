/// Every fault type the IoT layer can detect on a solar plate.
enum PanelFaultType {
  none,
  hotspot,
  openCircuit,
  soiling,
  partialShading,
  microCrack,
  bypassDiodeFailure,
  inverterFault,
  overTemperature,
  underPerformance,
  connectionLoss,
  stringFailure,
}

extension PanelFaultX on PanelFaultType {
  bool get isActive => this != PanelFaultType.none;

  String get label {
    switch (this) {
      case PanelFaultType.none:
        return 'No Fault';
      case PanelFaultType.hotspot:
        return 'Hotspot Detected';
      case PanelFaultType.openCircuit:
        return 'Open Circuit';
      case PanelFaultType.soiling:
        return 'Dust & Soiling';
      case PanelFaultType.partialShading:
        return 'Partial Shading';
      case PanelFaultType.microCrack:
        return 'Micro Crack on Glass';
      case PanelFaultType.bypassDiodeFailure:
        return 'Bypass Diode Failure';
      case PanelFaultType.inverterFault:
        return 'Inverter Fault';
      case PanelFaultType.overTemperature:
        return 'Over Temperature';
      case PanelFaultType.underPerformance:
        return 'Under Performance';
      case PanelFaultType.connectionLoss:
        return 'IoT Connection Lost';
      case PanelFaultType.stringFailure:
        return 'String Failure';
    }
  }

  String get description {
    switch (this) {
      case PanelFaultType.none:
        return 'The plate is working normally.';
      case PanelFaultType.hotspot:
        return 'A cell area is overheating abnormally. This can burn the cell '
            'permanently and damage neighbouring cells of the same string.';
      case PanelFaultType.openCircuit:
        return 'The plate circuit is broken — it is producing almost zero '
            'current while other plates keep working.';
      case PanelFaultType.soiling:
        return 'Dust and dirt have covered the surface. Output has dropped '
            'badly until the plate is cleaned.';
      case PanelFaultType.partialShading:
        return 'A shadow (tree, cable, bird mess) is covering part of the '
            'plate and killing most of its production.';
      case PanelFaultType.microCrack:
        return 'Hairline cracks are detected on the glass/cells. Power is '
            'reduced and the crack can grow with heat.';
      case PanelFaultType.bypassDiodeFailure:
        return 'The bypass diode has failed, so the string cannot skip this '
            'plate during shading — the whole series suffers.';
      case PanelFaultType.inverterFault:
        return 'The DC/AC conversion stage for this plate is not responding.';
      case PanelFaultType.overTemperature:
        return 'Plate temperature crossed the safe limit. Continuous high '
            'heat ages the cells quickly.';
      case PanelFaultType.underPerformance:
        return 'The plate is producing far less than expected for the current '
            'sunlight — a hidden fault is likely.';
      case PanelFaultType.connectionLoss:
        return 'The IoT device of this plate stopped responding. The plate '
            'cannot be monitored until the link is restored.';
      case PanelFaultType.stringFailure:
        return 'A full string inside the plate has failed — heavy production '
            'loss.';
    }
  }

  String get recommendation {
    switch (this) {
      case PanelFaultType.none:
        return 'No action needed. Keep monitoring from the app.';
      case PanelFaultType.hotspot:
        return 'Turn this plate OFF from the app and call a technician to '
            'inspect/replace the affected cells immediately.';
      case PanelFaultType.openCircuit:
        return 'Check connectors and cabling, then request a technician '
            'repair from the alert screen.';
      case PanelFaultType.soiling:
        return 'Schedule a cleaning visit — plates regain full output right '
            'after a proper wash.';
      case PanelFaultType.partialShading:
        return 'Remove the shading source (trim branches, clean droppings) '
            'or reposition the plate.';
      case PanelFaultType.microCrack:
        return 'Get the plate inspected and replaced if the crack spreads — '
            'cracks grow with daily heat cycles.';
      case PanelFaultType.bypassDiodeFailure:
        return 'Ask the technician to replace the bypass diode box of this '
            'plate.';
      case PanelFaultType.inverterFault:
        return 'Restart the inverter from the Control screen; if it persists, '
            'call the inverter service centre.';
      case PanelFaultType.overTemperature:
        return 'Improve airflow behind the plate and reduce load during peak '
            'heat hours.';
      case PanelFaultType.underPerformance:
        return 'Run Diagnostics from the plate screen and request a technician '
            'visit if the issue repeats.';
      case PanelFaultType.connectionLoss:
        return 'Check the IoT device power/Wi-Fi of this plate, then reconnect '
            'from the Control screen.';
      case PanelFaultType.stringFailure:
        return 'A serious internal failure — replace the plate to protect the '
            'performance of the full array.';
    }
  }

  /// How much a permanent fault hurts the health score per tick.
  int get healthPenalty {
    switch (this) {
      case PanelFaultType.none:
        return 0;
      case PanelFaultType.hotspot:
      case PanelFaultType.stringFailure:
      case PanelFaultType.microCrack:
        return 4;
      case PanelFaultType.openCircuit:
      case PanelFaultType.bypassDiodeFailure:
      case PanelFaultType.inverterFault:
        return 3;
      case PanelFaultType.overTemperature:
      case PanelFaultType.soiling:
      case PanelFaultType.partialShading:
        return 2;
      default:
        return 1;
    }
  }

  bool get isCritical {
    return this == PanelFaultType.hotspot ||
        this == PanelFaultType.stringFailure ||
        this == PanelFaultType.microCrack ||
        this == PanelFaultType.inverterFault ||
        this == PanelFaultType.openCircuit;
  }
}
