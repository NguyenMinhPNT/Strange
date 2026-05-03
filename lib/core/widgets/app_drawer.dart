import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../../app/router/route_paths.dart';

/// Navigation drawer with Home / Stats / Settings / About items.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurfaceBase
          : AppColors.surfaceBase,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.space24),
              child: Text('Strange', style: AppTextStyles.appTitle),
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isSelected: currentRoute == RoutePaths.home,
              onTap: () {
                Navigator.pop(context);
                context.go(RoutePaths.home);
              },
            ),
            _DrawerItem(
              icon: Icons.bar_chart_outlined,
              label: 'Stats',
              isSelected: currentRoute == RoutePaths.stats,
              onTap: () {
                Navigator.pop(context);
                context.go(RoutePaths.stats);
              },
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              isSelected: currentRoute == RoutePaths.settings,
              onTap: () {
                Navigator.pop(context);
                context.go(RoutePaths.settings);
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline,
              label: 'About',
              isSelected: currentRoute == RoutePaths.about,
              onTap: () {
                Navigator.pop(context);
                context.go(RoutePaths.about);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: AppTextStyles.body.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textOnSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      selectedTileColor: AppColors.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      onTap: onTap,
    );
  }
}
