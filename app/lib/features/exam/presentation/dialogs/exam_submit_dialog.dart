import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';

/// Dialog xác nhận nộp bài thi sát hạch (Modern Material 3)
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
    return showAppDialog(
      context: context,
      builder: (_) => ExamSubmitDialog(
        unansweredCount: unansweredCount,
        onConfirmSubmit: onConfirmSubmit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasUnanswered = unansweredCount > 0;

    return AppConfirmDialog(
      icon: hasUnanswered ? Icons.warning_amber_rounded : Icons.task_alt_rounded,
      iconColor: hasUnanswered ? AppColors.warning : AppColors.primary,
      iconBackgroundColor:
          hasUnanswered ? AppColors.warningContainer : AppColors.primaryContainer,
      title: 'Nộp bài thi?',
      message: hasUnanswered
          ? 'Bạn vẫn còn $unansweredCount câu hỏi chưa chọn đáp án. Bạn có chắc chắn muốn nộp bài để chấm điểm ngay bây giờ?'
          : 'Bạn đã hoàn thành trả lời đủ 25 câu hỏi. Nộp bài ngay để xem kết quả sát hạch?',
      cancelText: hasUnanswered ? 'Làm tiếp' : 'Xem lại bài',
      confirmText: hasUnanswered ? 'Vẫn nộp bài' : 'Nộp bài ngay',
      onConfirm: onConfirmSubmit,
    );
  }
}
