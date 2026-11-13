import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/maintenance_record.dart';

/// One maintenance log entry.
class MaintenanceTile extends StatelessWidget {
  const MaintenanceTile({super.key, required this.record});

  final MaintenanceRecord record;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF7A021).withOpacity(0.16),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(record.type.icon,
                size: 18, color: const Color(0xFFFF7E2D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      record.type.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: p.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: record.status == MaintenanceStatus.completed
                            ? const Color(0xFF2E9E5B).withOpacity(0.15)
                            : const Color(0xFFF5A524).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        record.status.label,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color:
                              record.status == MaintenanceStatus.completed
                                  ? const Color(0xFF2E9E5B)
                                  : const Color(0xFFF5A524),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppFormatters.date(record.date),
                      style: TextStyle(fontSize: 10, color: p.textFaint),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  record.note,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.35,
                    color: p.textSecondary,
                  ),
                ),
                if (record.technician.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Technician: ${record.technician}',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: p.textFaint,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
