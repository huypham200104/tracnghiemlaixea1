import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog xác nhận thoát bài thi sát hạch giữa chừng (SRP)
class ExamExitDialog extends StatelessWidget {
  final VoidCallback onConfirmExit;

  const ExamExitDialog({
    super.key,
    required this.onConfirmExit,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirmExit}) {
    return showDialog(
      context: context,
      builder: (_) => ExamExitDialog(onConfirmExit: onConfirmExit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thoát bài thi?'),
      content: const Text(
        'Bài làm của bạn đang dở dang và sẽ không được lưu vào lịch sử nếu thoát bây giờ.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Làm tiếp'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmExit();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Thoát', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
