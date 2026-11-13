import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/ui_helpers.dart';

/// Material 3 bottom navigation with a live alert badge.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.alertBadge,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int alertBadge;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return NavigationBar(
      height: 68,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: p.surface,
      indicatorColor: const Color(0xFFF7A021).withOpacity(0.18),
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: AppStrings.dashboard,
        ),
        const NavigationDestination(
          icon: Icon(Icons.solar_power_outlined),
          selectedIcon: Icon(Icons.solar_power),
          label: AppStrings.myPanels,
        ),
        const NavigationDestination(
          icon: Icon(Icons.power_settings_new_outlined),
          selectedIcon: Icon(Icons.power_settings_new),
          label: AppStrings.control,
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: alertBadge > 0,
            label: Text('$alertBadge'),
            backgroundColor: const Color(0xFFE5484D),
            child: const Icon(Icons.notifications_active_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: alertBadge > 0,
            label: Text('$alertBadge'),
            backgroundColor: const Color(0xFFE5484D),
            child: const Icon(Icons.notifications_active),
          ),
          label: AppStrings.alerts,
        ),
        const NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: AppStrings.settings,
        ),
      ],
    );
  }
}
