import 'package:flutter/material.dart';

import '../../../core/theme/ui_helpers.dart';

/// Greeting header (Good Morning, Owner).
class DashboardGreeting extends StatelessWidget {
  const DashboardGreeting({
    super.key,
    required this.name,
    required this.greeting,
  });

  final String name;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final String shortName =
        name.split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$greeting, $shortName',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        Text(
          'Your solar system is being watched 24/7',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: p.textFaint),
        ),
      ],
    );
  }
}
