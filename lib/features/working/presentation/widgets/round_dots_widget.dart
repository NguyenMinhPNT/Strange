import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Displays filled/empty round indicator dots for Pomodoro progress.
class RoundDotsWidget extends StatelessWidget {
  const RoundDotsWidget({
    super.key,
    required this.completedRounds,
    required this.shortBreakInterval,
  });

  final int completedRounds;
  final int shortBreakInterval;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(shortBreakInterval, (i) {
        final isDone = i <
            (completedRounds % shortBreakInterval == 0 && completedRounds > 0
                ? shortBreakInterval
                : completedRounds % shortBreakInterval);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.primary : AppColors.surfaceMuted,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        );
      }),
    );
  }
}
