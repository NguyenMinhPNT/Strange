import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/timer_service.dart';

/// Large stopwatch display for Deep Work sessions.
class StopwatchDisplay extends StatelessWidget {
  const StopwatchDisplay({
    super.key,
    required this.elapsedWorkSeconds,
    required this.isPaused,
  });

  final int elapsedWorkSeconds;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = TimerService.formatHhMmSs(elapsedWorkSeconds);

    return Column(
      children: [
        AnimatedOpacity(
          opacity: isPaused ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            timeStr,
            style: AppTextStyles.timerDisplay.copyWith(
              color: isDark ? Colors.white : AppColors.textPrimary,
              fontSize: 64,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isPaused ? 'Paused' : 'Focused',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: isPaused ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
