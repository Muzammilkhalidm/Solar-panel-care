import '../entities/diagnostic_report.dart';
import '../entities/panel.dart';

/// Contract for the guided diagnostics flow.
abstract class DiagnosticsRepository {
  Future<DiagnosticReport> runDiagnostics(Panel panel);
}
