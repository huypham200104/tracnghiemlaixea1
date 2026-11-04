import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog xác nhận nộp bài thi sát hạch (Material 3 Native)
class ExamSubmitDialog extends StatelessWidget {
  final int unansweredCount;
  final VoidCallback onConfirmSubmit;

  const ExamSubmitDialog({
    super.key,
    required this.unansweredCount,
    required this.onConfirmSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required int unansweredCount,
    required VoidCallback onConfirmSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (_) => ExamSubmitDialog(
        unansweredCount: unansweredCount,
        onConfirmSubmit: onConfirmSubmit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'Nộp bài thi?',
        style: AppTypography.titleLarge.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
      ),
      content: Text(
        unansweredCount > 0
            ? 'Bạn còn $unansweredCount câu chưa trả lời. Bạn có chắc chắn muốn nộp bài thi để chấm điểm ngay?'
            : 'Bạn đã trả lời đủ 25 câu hỏi. Nộp bài ngay để xem kết quả sát hạch?',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Xem lại bài'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmSubmit();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Nộp bài ngay'),
        ),
      ],
    );
  }
}
