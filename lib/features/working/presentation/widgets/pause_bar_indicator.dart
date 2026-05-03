import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/deep_work_constants.dart';

/// PauseBarIndicator shows how much of the pause budget has been used.
/// The bar fills from left to right; it turns red when < 30s remain.
class PauseBarIndicator extends StatelessWidget {
  const PauseBarIndicator({
    super.key,
    required this.pauseElapsedSeconds,
    required this.maxPauseSeconds,
  });

  final int pauseElapsedSeconds;
  final int maxPauseSeconds;

  @override
  Widget build(BuildContext context) {
    final remaining =
        (maxPauseSeconds - pauseElapsedSeconds).clamp(0, maxPauseSeconds);
    final ratio =
        maxPauseSeconds > 0 ? pauseElapsedSeconds / maxPauseSeconds : 0.0;
    final isUrgent = remaining <= DeepWorkConstants.pauseWarningSeconds;

    final barColor = isUrgent ? AppColors.error : AppColors.primary;
    final remainingStr = _formatMmSs(remaining);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pause budget',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$remainingStr remaining',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isUrgent ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  String _formatMmSs(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
