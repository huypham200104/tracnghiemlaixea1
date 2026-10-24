import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Widget đồng hồ đếm ngược thời gian làm bài thi sát hạch (19 phút)
class TimerWidget extends StatelessWidget {
  final int remainingSeconds;

  const TimerWidget({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final bool isWarning = remainingSeconds <= AppConstants.examWarningSeconds;

    final bgColor = isWarning ? AppColors.errorContainer : AppColors.primaryContainer;
    final fgColor = isWarning ? AppColors.error : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: fgColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWarning ? Icons.timer_outlined : Icons.timer,
            size: 16,
            color: fgColor,
          ),
          const SizedBox(width: 6),
          Text(
            formattedTime,
            style: AppTypography.labelLarge.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
