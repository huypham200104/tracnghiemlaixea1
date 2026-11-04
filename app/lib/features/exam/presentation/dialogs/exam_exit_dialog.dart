import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog xác nhận thoát bài thi sát hạch dở dang (Material 3 Native)
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'Dừng bài thi?',
        style: AppTypography.titleLarge.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
      ),
      content: Text(
        'Bài làm của bạn đang dở dang và sẽ không được lưu vào lịch sử nếu thoát ngay bây giờ.',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tiếp tục làm'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmExit();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Thoát bài thi'),
        ),
      ],
    );
  }
}
