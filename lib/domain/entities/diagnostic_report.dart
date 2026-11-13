/// Result of the guided diagnostics run on a single plate.
class DiagnosticCheck {
  DiagnosticCheck({
    required this.name,
    required this.passed,
    required this.detail,
    required this.value,
  });

  final String name;
  final bool passed;
  final String detail;
  final String value;

  Map<String, dynamic> toJson() => {
        'name': name,
        'passed': passed,
        'detail': detail,
        'value': value,
      };

  factory DiagnosticCheck.fromJson(Map<String, dynamic> json) {
    return DiagnosticCheck(
      name: json['name'] as String,
      passed: json['passed'] as bool? ?? false,
      detail: json['detail'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class DiagnosticReport {
  DiagnosticReport({
    required this.id,
    required this.panelId,
    required this.panelName,
    required this.startedAt,
    required this.completedAt,
    required this.checks,
    required this.overallHealth,
    required this.recommendation,
  });

  final String id;
  final String panelId;
  final String panelName;
  final DateTime startedAt;
  final DateTime completedAt;
  final List<DiagnosticCheck> checks;
  final int overallHealth;
  final String recommendation;

  bool get allPassed => checks.every((c) => c.passed);

  int get passedCount => checks.where((c) => c.passed).length;

  int get totalCount => checks.length;
}
