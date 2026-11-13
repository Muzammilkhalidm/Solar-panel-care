import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/ui_helpers.dart';
import '../../common/image_banner.dart';
import 'auth_footer.dart';

/// Shared scaffold for login / register screens: photo header + card form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack)
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              const SizedBox(height: 4),
              ImageBanner(
                asset: AppAssets.imgSunset,
                height: 148,
                borderRadius: 22,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7A021),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.solar_power,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: p.cardBorder),
                  boxShadow: p.cardShadow,
                ),
                child: Column(children: children),
              ),
              const SizedBox(height: 18),
              const AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
