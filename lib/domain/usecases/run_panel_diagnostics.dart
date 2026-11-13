import '../../data/repositories/diagnostics_repository_impl.dart';
import '../entities/diagnostic_report.dart';
import '../entities/panel.dart';

/// Runs the full guided diagnostics on a single plate.
class RunPanelDiagnostics {
  RunPanelDiagnostics(this._repo);
  final DiagnosticsRepositoryImpl _repo;

  Future<DiagnosticReport> execute(Panel panel) => _repo.runDiagnostics(panel);
}
