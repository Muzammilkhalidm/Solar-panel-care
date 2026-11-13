import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';

/// Big labelled chip used on the panel detail header.
class PanelStatusChip extends StatelessWidget {
  const PanelStatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Health ring painter (0-100) with center label.
class HealthRing extends StatelessWidget {
  const HealthRing({
    super.key,
    required this.score,
    this.size = 92,
  });

  final int score;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final Color color = score >= 80
        ? const Color(0xFF2E9E5B)
        : score >= 55
            ? const Color(0xFFF5A524)
            : const Color(0xFFE5484D);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: score / 100,
          track: p.surfaceAlt,
          color: color,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: size * 0.26,
                  fontWeight: FontWeight.w900,
                  color: p.textPrimary,
                ),
              ),
              Text(
                'HEALTH',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: p.textFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.color,
  });

  final double progress;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double stroke = size.width * 0.09;
    final Rect rect = Offset(stroke, stroke) &
        Size(size.width - stroke * 2, size.height - stroke * 2);

    final Paint bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(rect, 0, 3.14159 * 2, false, bg);

    final Paint fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, -1.5708, 3.14159 * 2 * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.color != color;
}
