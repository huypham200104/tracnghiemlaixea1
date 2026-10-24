import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog xác nhận trước khi bắt đầu bài thi sát hạch (SRP)
class ExamStartDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ExamStartDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      builder: (_) => ExamStartDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.assignment_outlined, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Bắt đầu bài thi?',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• Đề thi gồm ${AppConstants.examQuestionCount} câu hỏi ngẫu nhiên.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '• Thời gian làm bài: ${AppConstants.examDurationMinutes} phút.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '• Điều kiện ĐẠT: Đúng ≥ ${AppConstants.passingScore}/${AppConstants.examQuestionCount} câu.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cảnh báo: Trả lời sai 1 câu điểm liệt sẽ bị TRƯỢT ngay lập tức!',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Để sau',
            style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Bắt đầu làm bài'),
        ),
      ],
    );
  }
}
