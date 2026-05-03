import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/claymorphism/clay_theme.dart';
import '../../../home/domain/entities/enums/card_type.dart';
import '../../../home/domain/entities/strange_card.dart';

class TimerBackground extends StatelessWidget {
  const TimerBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final surface =
        context.isDark ? AppColors.darkSurfaceBase : AppColors.surfaceBase;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        gradient: const RadialGradient(
          center: Alignment(0, -0.15),
          radius: 1.05,
          colors: [
            Colors.white,
            AppColors.surfaceElevated,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 110,
            left: -40,
            child: _GlowOrb(
              diameter: 180,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            top: 320,
            right: -40,
            child: _GlowOrb(
              diameter: 150,
              color: const Color(0xFF4A90E2).withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 40,
            child: _GlowOrb(
              diameter: 120,
              color: const Color(0xFF27AE60).withValues(alpha: 0.04),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerTopBar extends StatelessWidget {
  const TimerTopBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderButton(
          icon: Icons.arrow_back_rounded,
          iconColor: AppColors.primary,
          onTap: onBack,
        ),
        const Spacer(),
        Text(
          'Strange',
          style: AppTextStyles.appTitle.copyWith(fontSize: 34),
        ),
        const Spacer(),
        const SizedBox(width: 56),
      ],
    );
  }
}

class TimerCardInfoPanel extends StatelessWidget {
  const TimerCardInfoPanel({super.key, required this.card});

  final StrangeCard card;

  @override
  Widget build(BuildContext context) {
    final cardColor = _colorFromHex(card.colorHex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: context.clayRaised(radius: 30),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor,
                  cardColor.withValues(alpha: 0.82),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: cardColor.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _iconForType(card.type),
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.name,
                  style: AppTextStyles.heading.copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  card.type.displayName,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}

enum TimerScreenMode { pomodoro, deepWork }

class TimerModeSwitch extends StatelessWidget {
  const TimerModeSwitch({
    super.key,
    required this.activeMode,
    this.onPomodoro,
    this.onDeepWork,
  });

  final TimerScreenMode activeMode;
  final VoidCallback? onPomodoro;
  final VoidCallback? onDeepWork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: context.clayRaised(radius: 26),
      child: Row(
        children: [
          Expanded(
            child: _ModeTab(
              label: 'Pomodoro',
              isActive: activeMode == TimerScreenMode.pomodoro,
              onTap: onPomodoro,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ModeTab(
              label: 'Deep Work',
              isActive: activeMode == TimerScreenMode.deepWork,
              onTap: onDeepWork,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerBannerChip extends StatelessWidget {
  const TimerBannerChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class TimerStatsStrip extends StatelessWidget {
  const TimerStatsStrip({super.key, required this.items});

  final List<TimerStatItemData> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: context.clayRaised(radius: 30),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Expanded(child: _TimerStatItem(item: items[index])),
            if (index != items.length - 1)
              Container(
                width: 1,
                height: 58,
                color: AppColors.surfaceMuted,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
          ],
        ],
      ),
    );
  }
}

class TimerStatItemData {
  const TimerStatItemData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
}

class TimerSummaryPanel extends StatelessWidget {
  const TimerSummaryPanel({
    super.key,
    required this.rows,
  });

  final List<TimerSummaryRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: context.clayRaised(radius: 28),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            _TimerSummaryRow(row: rows[index]),
            if (index != rows.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }
}

class TimerSummaryRowData {
  const TimerSummaryRowData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
}

class TimerSideActionButton extends StatelessWidget {
  const TimerSideActionButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 104,
        decoration: context.clayRaised(radius: 32),
        child: Icon(icon, color: iconColor, size: 42),
      ),
    );
  }
}

class TimerCenterActionButton extends StatelessWidget {
  const TimerCenterActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.24),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
            const BoxShadow(
              color: AppColors.clayHighlight,
              blurRadius: 12,
              offset: Offset(-4, -4),
              spreadRadius: -6,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 54),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: context.clayRaised(radius: 18),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isActive,
    this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : AppColors.textOnSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(22),
              ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyBold.copyWith(
            color: textColor.withValues(
                alpha: onTap == null && !isActive ? 0.45 : 1),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _TimerStatItem extends StatelessWidget {
  const _TimerStatItem({required this.item});

  final TimerStatItemData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.iconColor.withValues(alpha: 0.1),
          ),
          child: Icon(item.icon, color: item.iconColor),
        ),
        const SizedBox(height: 10),
        Text(
          item.label,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          style: AppTextStyles.bodyBold.copyWith(
            color: item.iconColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _TimerSummaryRow extends StatelessWidget {
  const _TimerSummaryRow({required this.row});

  final TimerSummaryRowData row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: context.clayRaised(radius: 14),
          child: Icon(row.icon, color: row.iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            row.label,
            style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
          ),
        ),
        Text(
          row.value,
          style: AppTextStyles.bodyBold.copyWith(
            fontSize: 18,
            color: row.valueColor,
          ),
        ),
      ],
    );
  }
}

IconData _iconForType(CardType type) {
  switch (type) {
    case CardType.learning:
      return Icons.chat_bubble_rounded;
    case CardType.project:
      return Icons.work_rounded;
    case CardType.habit:
      return Icons.favorite_rounded;
  }
}

Color _colorFromHex(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return AppColors.primary;
  }
}
