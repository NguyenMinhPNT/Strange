import 'package:flutter/material.dart';

import '../../../../core/widgets/clay_button.dart';
import '../../../../core/theme/app_colors.dart';

enum TimerControlMode { running, paused, initial }

/// Control buttons row for Pomodoro and Deep Work timers.
class TimerControlButtons extends StatelessWidget {
  const TimerControlButtons({
    super.key,
    required this.mode,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onEnd,
    this.onSkipBreak,
    this.showSkipBreak = false,
  });

  final TimerControlMode mode;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onEnd;
  final VoidCallback? onSkipBreak;
  final bool showSkipBreak;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (mode == TimerControlMode.initial) ...[
          ClayButton(
            label: 'Start',
            onTap: onStart,
            icon: Icons.play_arrow_rounded,
            width: 180,
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (mode == TimerControlMode.running)
                ClayButton(
                  label: 'Pause',
                  onTap: onPause,
                  icon: Icons.pause_rounded,
                  isPrimary: false,
                  width: 130,
                ),
              if (mode == TimerControlMode.paused)
                ClayButton(
                  label: 'Resume',
                  onTap: onResume,
                  icon: Icons.play_arrow_rounded,
                  width: 130,
                ),
              const SizedBox(width: 12),
              ClayButton(
                label: 'End',
                onTap: onEnd,
                icon: Icons.stop_rounded,
                isPrimary: false,
                color: AppColors.error.withValues(alpha: 0.15),
                textColor: AppColors.error,
                width: 110,
              ),
            ],
          ),
        ],
        if (showSkipBreak && onSkipBreak != null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onSkipBreak,
            icon: const Icon(Icons.skip_next_rounded, size: 16),
            label: const Text('Skip Break'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
