import '../../domain/entities/diagnostic_report.dart';

/// JSON-mappable variant of [DiagnosticReport].
class DiagnosticReportModel extends DiagnosticReport {
  DiagnosticReportModel({
    required super.id,
    required super.panelId,
    required super.panelName,
    required super.startedAt,
    required super.completedAt,
    required super.checks,
    required super.overallHealth,
    required super.recommendation,
  });

  factory DiagnosticReportModel.fromEntity(DiagnosticReport r) =>
      DiagnosticReportModel(
        id: r.id,
        panelId: r.panelId,
        panelName: r.panelName,
        startedAt: r.startedAt,
        completedAt: r.completedAt,
        checks: r.checks,
        overallHealth: r.overallHealth,
        recommendation: r.recommendation,
      );

  factory DiagnosticReportModel.fromJson(Map<String, dynamic> json) {
    return DiagnosticReportModel(
      id: json['id'] as String,
      panelId: json['panelId'] as String,
      panelName: json['panelName'] as String? ?? '—',
      startedAt:
          DateTime.tryParse(json['startedAt'] as String? ?? '') ??
              DateTime.now(),
      completedAt:
          DateTime.tryParse(json['completedAt'] as String? ?? '') ??
              DateTime.now(),
      checks: (json['checks'] as List? ?? [])
          .map((e) =>
              DiagnosticCheck.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      overallHealth: json['overallHealth'] as int? ?? 0,
      recommendation: json['recommendation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'panelId': panelId,
        'panelName': panelName,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt.toIso8601String(),
        'checks': checks.map((c) => c.toJson()).toList(),
        'overallHealth': overallHealth,
        'recommendation': recommendation,
      };
}
