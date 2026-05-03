import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/claymorphism/clay_theme.dart';

/// Generic clay container — simpler than ClayCard (no built-in padding defaults).
class ClayContainer extends StatelessWidget {
  const ClayContainer({
    super.key,
    required this.child,
    this.color,
    this.radius = AppDimensions.radiusContainer,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  final Widget child;
  final Color? color;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: context.clayRaised(color: color, radius: radius),
      padding: padding,
      child: child,
    );
  }
}
