import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/ui_helpers.dart';

/// Friendly empty state with an optional real-life photo.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.solar_power,
    this.imageAsset,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? imageAsset;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAsset != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.85,
                  child: Image.asset(
                    imageAsset!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: p.textFaint),
              ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 19),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Photo-backed empty state used on the panels screen.
class EmptyStateWithPhoto extends StatelessWidget {
  const EmptyStateWithPhoto({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: title,
      message: message,
      imageAsset: AppAssets.imgSolarFarm,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
