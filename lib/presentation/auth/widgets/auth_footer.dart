import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/ui_helpers.dart';

/// Small credit footer used at the bottom of auth screens.
class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite,
                  size: 13, color: Color(0xFFE5484D)),
              const SizedBox(width: 6),
              Text(
                AppConstants.developerCredit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: p.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Opacity(
              opacity: 0.8,
              child: SizedBox(
                height: 30,
                width: 140,
                child: Image.asset(
                  AppAssets.imgTechnician,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
