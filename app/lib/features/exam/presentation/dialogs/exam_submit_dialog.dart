import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog xác nhận nộp bài thi sát hạch (SRP)
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
      title: const Text('Xác nhận nộp bài?'),
      content: Text(
        unansweredCount > 0
            ? 'Bạn vẫn còn $unansweredCount câu chưa trả lời. Bạn có chắc chắn muốn nộp bài thi ngay bây giờ?'
            : 'Bạn đã hoàn thành đủ 25 câu hỏi. Nộp bài ngay để xem kết quả thi?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Xem lại bài'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmSubmit();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Nộp bài ngay'),
        ),
      ],
    );
  }
}
