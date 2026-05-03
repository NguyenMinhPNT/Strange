import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/enums/pomodoro_phase.dart';

/// CircularCountdown draws the arc progress ring for Pomodoro sessions.
class CircularCountdown extends StatefulWidget {
  const CircularCountdown({
    super.key,
    required this.phase,
    required this.progress,
    required this.remainingSeconds,
    required this.isRunning,
  });

  final PomodoroPhase phase;
  final double progress; // 0.0 – 1.0
  final int remainingSeconds;
  final bool isRunning;

  @override
  State<CircularCountdown> createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.03).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget countdown = CustomPaint(
      size: const Size(260, 260),
      painter: _CircularCountdownPainter(
        progress: widget.progress,
        isDark: isDark,
      ),
      child: SizedBox(
        width: 260,
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(widget.remainingSeconds),
              style: AppTextStyles.timerDisplay.copyWith(
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.phase.displayLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 1.5,
              ),
            ),
          ],
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
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _CircularCountdownPainter extends CustomPainter {
  const _CircularCountdownPainter({
    required this.progress,
    required this.isDark,
  });

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 12.0;
    const startAngle = -1.5707963; // -π/2 (12 o'clock)

    // Background arc
    final bgPaint = Paint()
      ..color = isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceMuted
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        6.2831853 * progress, // 2π * progress
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularCountdownPainter old) =>
      old.progress != progress || old.isDark != isDark;
}
