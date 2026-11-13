import 'package:flutter/material.dart';

/// Blocking scrim with spinner while a future runs.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.busy,
    required this.child,
    this.label = 'Please wait…',
  });

  final bool busy;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (busy)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black38,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(strokeWidth: 2.6),
                        const SizedBox(height: 12),
                        Text(label, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
