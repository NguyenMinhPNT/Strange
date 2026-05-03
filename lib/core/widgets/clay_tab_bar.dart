import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../theme/claymorphism/clay_styles.dart';
import '../theme/claymorphism/clay_theme.dart';

/// Clay-styled tab bar for Learning / Projects / Habits.
class ClayTabBar extends StatelessWidget {
  const ClayTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.tabBarHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      decoration: context.clayRaised(
        radius: AppDimensions.radiusButton,
        color: context.isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.surfaceMuted,
      ),
      padding: const EdgeInsets.all(AppDimensions.tabBarPadding),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: isSelected
                    ? ClayStyles.primary(
                        radius:
                            AppDimensions.radiusButton -
                            AppDimensions.tabBarPadding,
                      )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: AppTextStyles.button.copyWith(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
