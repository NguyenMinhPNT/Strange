import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/enums/pomodoro_phase.dart';

/// CircularCountdown renders the Pomodoro countdown ring.
class CircularCountdown extends StatefulWidget {
  const CircularCountdown({
    super.key,
    required this.phase,
    required this.progress,
    required this.remainingSeconds,
    required this.isRunning,
    this.size = 300,
  });

  final PomodoroPhase phase;
  final double progress;
  final int remainingSeconds;
  final bool isRunning;
  final double size;

  @override
  State<CircularCountdown> createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown>
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
    final progressColor = _phaseColor(widget.phase);

    Widget countdown = Container(
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
          painter: _CircularCountdownPainter(
            progress: widget.progress.clamp(0.0, 1.0),
            isDark: isDark,
            progressColor: progressColor,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: progressColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    _phaseIcon(widget.phase),
                    color: progressColor,
                    size: 28,
                  ),
                ),
                SizedBox(height: widget.size * 0.08),
                Text(
                  _formatTime(widget.remainingSeconds),
                  style: AppTextStyles.timerDisplay.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontSize: widget.size * 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _phaseLabel(widget.phase),
                  style: AppTextStyles.body.copyWith(
                    color: progressColor.withValues(alpha: 0.72),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.isRunning) {
      countdown = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (_, child) =>
            Transform.scale(scale: _pulseAnimation.value, child: child),
        child: countdown,
      );
    }

    return countdown;
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Color _phaseColor(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return AppColors.primary;
      case PomodoroPhase.shortBreak:
        return const Color(0xFF4A90E2);
      case PomodoroPhase.longBreak:
        return const Color(0xFF27AE60);
    }
  }

  IconData _phaseIcon(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return Icons.gps_fixed_rounded;
      case PomodoroPhase.shortBreak:
        return Icons.free_breakfast_rounded;
      case PomodoroPhase.longBreak:
        return Icons.spa_rounded;
    }
  }

  String _phaseLabel(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return 'Focus Session';
      case PomodoroPhase.shortBreak:
        return 'Short Break';
      case PomodoroPhase.longBreak:
        return 'Long Break';
    }
  }
}

class _CircularCountdownPainter extends CustomPainter {
  const _CircularCountdownPainter({
    required this.progress,
    required this.isDark,
    required this.progressColor,
  });

  final double progress;
  final bool isDark;
  final Color progressColor;

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
          progressColor.withValues(alpha: 0.35),
          progressColor,
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
        ..color = progressColor.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(
      knobCenter,
      strokeWidth * 0.62,
      Paint()..color = progressColor,
    );
  }

  @override
  bool shouldRepaint(_CircularCountdownPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.progressColor != progressColor;
  }
}
