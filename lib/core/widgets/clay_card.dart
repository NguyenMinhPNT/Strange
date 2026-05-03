import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/claymorphism/clay_theme.dart';

/// A generic clay-morphic card container with raised shadow.
class ClayCard extends StatelessWidget {
  const ClayCard({
    super.key,
    required this.child,
    this.color,
    this.radius = AppDimensions.radiusCard,
    this.padding = const EdgeInsets.all(AppDimensions.cardPadding),
    this.margin,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = context.clayRaised(color: color, radius: radius);

    Widget content = Container(
      decoration: decoration,
      padding: padding,
      child: child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
