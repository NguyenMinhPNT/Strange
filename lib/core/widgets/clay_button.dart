import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../theme/claymorphism/clay_styles.dart';
import '../theme/claymorphism/clay_theme.dart';

/// A pressable clay-morphic button.
class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
    this.icon,
    this.width,
    this.height = 52.0,
    this.radius = AppDimensions.radiusButton,
    this.isPrimary = true,
    this.isEnabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double height;
  final double radius;
  final bool isPrimary;
  final bool isEnabled;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        widget.color ?? (widget.isPrimary ? AppColors.primary : null);
    final effectiveTextColor =
        widget.textColor ??
        (widget.isPrimary ? AppColors.onPrimary : AppColors.textPrimary);

    BoxDecoration decoration;
    if (widget.isPrimary) {
      decoration = ClayStyles.primary(
        radius: widget.radius,
        isPressed: _isPressed,
      );
    } else {
      decoration = context.clayRaised(radius: widget.radius);
      if (effectiveColor != null) {
        decoration = ClayStyles.coloredCard(
          cardColor: effectiveColor,
          radius: widget.radius,
          isPressed: _isPressed,
          isDark: context.isDark,
        );
      } else if (_isPressed) {
        decoration = context.clayPressed(radius: widget.radius);
      }
    }

    return GestureDetector(
      onTapDown: widget.isEnabled
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.isEnabled
          ? (_) => setState(() => _isPressed = false)
          : null,
      onTapCancel: widget.isEnabled
          ? () => setState(() => _isPressed = false)
          : null,
      onTap: widget.isEnabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.width,
          height: widget.height,
          decoration: decoration.copyWith(
            color: widget.isEnabled
                ? decoration.color
                : decoration.color?.withValues(alpha: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: widget.width == null
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: effectiveTextColor, size: 20),
                const SizedBox(width: AppDimensions.space8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: AppTextStyles.button.copyWith(
                    color: effectiveTextColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
