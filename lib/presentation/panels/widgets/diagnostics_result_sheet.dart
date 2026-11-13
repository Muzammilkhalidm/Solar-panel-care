import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../domain/entities/diagnostic_report.dart';
import '../../../core/utils/formatters.dart';

/// Bottom sheet showing the full diagnostics report.
Future<void> showDiagnosticsSheet(
  BuildContext context,
  DiagnosticReport report,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.94,
      builder: (_, controller) => _ReportBody(
        report: report,
        scrollController: controller,
      ),
    ),
  );
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.scrollController});

  final DiagnosticReport report;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: p.cardBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnostics Report — ${report.panelName}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: p.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${AppFormatters.dateTime(report.completedAt)} • '
                      'ID ${report.id}',
                      style: TextStyle(fontSize: 11, color: p.textFaint),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: report.allPassed
                      ? const Color(0xFF2E9E5B).withOpacity(0.15)
                      : const Color(0xFFE5484D).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${report.overallHealth}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: report.allPassed
                        ? const Color(0xFF2E9E5B)
                        : const Color(0xFFE5484D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: report.checks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final check = report.checks[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: p.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.cardBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        check.passed
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 19,
                        color: check.passed
                            ? const Color(0xFF2E9E5B)
                            : const Color(0xFFE5484D),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    check.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: p.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  check.value,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: check.passed
                                        ? const Color(0xFF2E9E5B)
                                        : const Color(0xFFE5484D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              check.detail,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.35,
                                color: p.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: p.infoSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              report.recommendation,
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                color: p.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
