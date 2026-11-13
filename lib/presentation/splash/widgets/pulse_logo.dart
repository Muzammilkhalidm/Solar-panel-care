import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/ui_helpers.dart';

/// Big animated sun logo used on the splash screen.
class PulseLogo extends StatefulWidget {
  const PulseLogo({super.key, this.size = 110});

  final double size;

  @override
  State<PulseLogo> createState() => _PulseLogoState();
}

class _PulseLogoState extends State<PulseLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.94, end: 1.06).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF7A021), Color(0xFFFF7E2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.size * 0.32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF7A021).withOpacity(0.45),
              blurRadius: 42,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.solar_power,
          size: widget.size * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Small rotating "hub connecting" indicator with status text.
class HubStatusChip extends StatelessWidget {
  const HubStatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: p.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience provider accessor used by several screens.
T watchP<T>(BuildContext context) => Provider.of<T>(context, listen: true);
