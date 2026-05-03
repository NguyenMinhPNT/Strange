import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_paths.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Custom navigation drawer inspired by the Strange concept art.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final isDark = theme.brightness == Brightness.dark;
    final elevated =
        isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.04);

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.86,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(40),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark ? const Color(0xFF29292C) : Colors.white,
                elevated,
                isDark ? const Color(0xFF1F2023) : const Color(0xFFF8F5F2),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -120,
                right: -100,
                child: _AmbientGlow(
                  size: 280,
                  color:
                      AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
                ),
              ),
              Positioned(
                bottom: -120,
                left: -100,
                child: _AmbientGlow(
                  size: 240,
                  color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.65),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DrawerHeaderCard(
                              surface: elevated,
                              borderColor: borderColor,
                              subtitle: 'Manage your time beautifully',
                            ),
                            const SizedBox(height: 22),
                            _DrawerActionCard(
                              icon: Icons.home_rounded,
                              label: loc.navHome,
                              isSelected: currentRoute == RoutePaths.home,
                              onTap: () => _navigate(context, RoutePaths.home),
                            ),
                            const SizedBox(height: 18),
                            _DrawerActionCard(
                              icon: Icons.bar_chart_rounded,
                              label: loc.navStats,
                              isSelected: currentRoute == RoutePaths.stats,
                              onTap: () => _navigate(context, RoutePaths.stats),
                            ),
                            const SizedBox(height: 18),
                            _DrawerActionCard(
                              icon: Icons.settings_rounded,
                              label: loc.navSettings,
                              isSelected: currentRoute == RoutePaths.settings,
                              onTap: () =>
                                  _navigate(context, RoutePaths.settings),
                            ),
                            const SizedBox(height: 18),
                            _DrawerActionCard(
                              icon: Icons.info_outline_rounded,
                              label: loc.navAbout,
                              isSelected: currentRoute == RoutePaths.about,
                              onTap: () => _navigate(context, RoutePaths.about),
                            ),
                            const SizedBox(height: 28),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                color: borderColor,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                loc.general.toUpperCase(),
                                style: AppTextStyles.sectionHeader.copyWith(
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _PreferencesCard(
                              surface: elevated,
                              borderColor: borderColor,
                              darkModeLabel: loc.darkMode,
                              languageLabel: loc.language,
                              currentLanguage: _languageLabel(
                                  Localizations.localeOf(context)),
                              darkModeEnabled: isDark,
                              onTapDarkMode: () => _navigate(
                                context,
                                RoutePaths.settings,
                              ),
                              onTapLanguage: () => _navigate(
                                context,
                                RoutePaths.settings,
                              ),
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 86,
                      child: _DrawerFooterScene(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }

  static String _languageLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return 'Tieng Viet';
      case 'en':
      default:
        return 'English';
    }
  }
}

class _DrawerHeaderCard extends StatelessWidget {
  const _DrawerHeaderCard({
    required this.surface,
    required this.borderColor,
    required this.subtitle,
  });

  final Color surface;
  final Color borderColor;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _raisedDecoration(
        color: surface,
        borderRadius: 30,
        borderColor: borderColor,
      ),
      child: Row(
        children: [
          const _AvatarBadge(),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Strange',
                    style: AppTextStyles.appTitle.copyWith(fontSize: 34)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      padding: const EdgeInsets.all(10),
      decoration: _raisedDecoration(
        color: Colors.white.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.08 : 1,
        ),
        borderRadius: 28,
        borderColor: Colors.white.withValues(alpha: 0.08),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.white,
              AppColors.surfaceMuted,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(4, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 18,
              right: 18,
              top: 16,
              child: Container(
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[Colors.white, Color(0xFFEAE5E1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 18,
              child: Container(
                height: 26,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFA5A0), Color(0xFFFF6670)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Container(
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withValues(alpha: 0.94),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerActionCard extends StatelessWidget {
  const _DrawerActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkSurfaceElevated : Colors.white);
    final iconColor = isSelected ? AppColors.primary : AppColors.textOnSurface;
    final textColor = isSelected ? Colors.white : AppColors.textOnSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: isSelected
              ? _selectedDecoration()
              : _raisedDecoration(
                  color: background,
                  borderRadius: 26,
                  borderColor: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white,
                ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: _raisedDecoration(
                  color: Colors.white,
                  borderRadius: 20,
                  borderColor: Colors.white.withValues(alpha: 0.7),
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.subheading.copyWith(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({
    required this.surface,
    required this.borderColor,
    required this.darkModeLabel,
    required this.languageLabel,
    required this.currentLanguage,
    required this.darkModeEnabled,
    required this.onTapDarkMode,
    required this.onTapLanguage,
  });

  final Color surface;
  final Color borderColor;
  final String darkModeLabel;
  final String languageLabel;
  final String currentLanguage;
  final bool darkModeEnabled;
  final VoidCallback onTapDarkMode;
  final VoidCallback onTapLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: _raisedDecoration(
        color: surface,
        borderRadius: 26,
        borderColor: borderColor,
      ),
      child: Column(
        children: [
          _PreferenceRow(
            icon: Icons.dark_mode_rounded,
            label: darkModeLabel,
            trailing: AbsorbPointer(
              child: Switch.adaptive(
                value: darkModeEnabled,
                onChanged: (_) {},
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.surfaceMuted,
              ),
            ),
            onTap: onTapDarkMode,
          ),
          Divider(color: borderColor, height: 8),
          _PreferenceRow(
            icon: Icons.language_rounded,
            label: languageLabel,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLanguage,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ],
            ),
            onTap: onTapLanguage,
          ),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: _raisedDecoration(
                  color: Colors.white,
                  borderRadius: 18,
                  borderColor: Colors.white.withValues(alpha: 0.7),
                ),
                child: Icon(icon, color: AppColors.textOnSurface, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerFooterScene extends StatelessWidget {
  const _DrawerFooterScene();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.02 : 0.45),
                  Colors.white.withValues(alpha: isDark ? 0.01 : 0.85),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(80),
              ),
            ),
          ),
        ),
        const Positioned(left: 16, bottom: 10, child: _MiniTree()),
        const Positioned(left: 44, bottom: 4, child: _MiniTree(scale: 0.72)),
        const Positioned(right: 18, bottom: 8, child: _MiniTree()),
        const Positioned(right: 40, bottom: 4, child: _MiniTree(scale: 0.7)),
      ],
    );
  }
}

class _MiniTree extends StatelessWidget {
  const _MiniTree({this.scale = 1});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 26,
        height: 40,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 7,
              height: 12,
              margin: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Positioned(
              bottom: 7,
              child: _treeLayer(width: 24, height: 14),
            ),
            Positioned(
              bottom: 15,
              child: _treeLayer(width: 18, height: 12),
            ),
            Positioned(
              bottom: 23,
              child: _treeLayer(width: 12, height: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _treeLayer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.white,
            Color(0xFFE8E4E0),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

BoxDecoration _raisedDecoration({
  required Color color,
  required double borderRadius,
  required Color borderColor,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: borderColor),
    boxShadow: [
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.85),
        blurRadius: 18,
        offset: const Offset(-6, -6),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.10),
        blurRadius: 20,
        offset: const Offset(8, 10),
      ),
    ],
  );
}

BoxDecoration _selectedDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(26),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF3A30), AppColors.primary],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.22),
        blurRadius: 14,
        offset: const Offset(-3, -3),
      ),
      const BoxShadow(
        color: AppColors.clayShadowPrimary,
        blurRadius: 22,
        offset: Offset(8, 12),
      ),
    ],
  );
}
