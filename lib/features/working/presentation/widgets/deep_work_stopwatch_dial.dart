import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/datasources/timer_service.dart';

class DeepWorkStopwatchDial extends StatefulWidget {
  const DeepWorkStopwatchDial({
    super.key,
    required this.elapsedWorkSeconds,
    required this.isPaused,
    this.size = 300,
  });

  final int elapsedWorkSeconds;
  final bool isPaused;
  final double size;

  @override
  State<DeepWorkStopwatchDial> createState() => _DeepWorkStopwatchDialState();
}

class _DeepWorkStopwatchDialState extends State<DeepWorkStopwatchDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 1, end: 1.02).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _progressForElapsed(widget.elapsedWorkSeconds);
    final accentSize = widget.size * 0.18;
    final iconSize = widget.size * 0.09;
    final timeFontSize = widget.size * 0.19;

    Widget dial = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceBase,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.92),
            blurRadius: 24,
            offset: const Offset(-10, -10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.32 : 0.1),
            blurRadius: 30,
            offset: const Offset(16, 18),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.size * 0.08),
        child: CustomPaint(
          painter: _DeepWorkDialPainter(
            progress: progress,
            isDark: isDark,
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: widget.isPaused ? 0.72 : 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = constraints.maxWidth * 0.82;
                return Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: accentSize,
                          height: accentSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            Icons.gps_fixed_rounded,
                            color: AppColors.primary,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(height: widget.size * 0.06),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            TimerService.formatHhMmSs(
                                widget.elapsedWorkSeconds),
                            maxLines: 1,
                            softWrap: false,
                            style: AppTextStyles.timerDisplay.copyWith(
                              color:
                                  isDark ? Colors.white : AppColors.textPrimary,
                              fontSize: timeFontSize,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.isPaused
                                ? 'Deep Work Paused'
                                : 'Deep Work Session',
                            maxLines: 1,
                            softWrap: false,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary.withValues(alpha: 0.72),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    if (!widget.isPaused && widget.elapsedWorkSeconds > 0) {
      dial = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (_, child) =>
            Transform.scale(scale: _pulseAnimation.value, child: child),
        child: dial,
      );
    }

    return dial;
  }

  double _progressForElapsed(int elapsedWorkSeconds) {
    if (elapsedWorkSeconds <= 0) return 0;
    return (elapsedWorkSeconds / 7200).clamp(0.0, 0.965);
  }
}

class _DeepWorkDialPainter extends CustomPainter {
  const _DeepWorkDialPainter({
    required this.progress,
    required this.isDark,
  });

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.05;
    final radius = size.width / 2 - strokeWidth / 2;
    const startAngle = -pi / 2;

    final trackPaint = Paint()
      ..color = isDark
          ? AppColors.darkSurfaceBase.withValues(alpha: 0.5)
          : AppColors.surfaceMuted
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final sweep = 2 * pi * progress;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + 2 * pi,
        colors: [
          AppColors.primary.withValues(alpha: 0.35),
          AppColors.primary,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      progressPaint,
    );

    final knobAngle = startAngle + sweep;
    final knobCenter = Offset(
      center.dx + radius * cos(knobAngle),
      center.dy + radius * sin(knobAngle),
    );

    canvas.drawCircle(
      knobCenter,
      strokeWidth * 0.88,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(
      knobCenter,
      strokeWidth * 0.62,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(_DeepWorkDialPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
