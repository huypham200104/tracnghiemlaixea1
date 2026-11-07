import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';

/// Dialog xác nhận thoát bài thi sát hạch dở dang (Modern Material 3)
class ExamExitDialog extends StatelessWidget {
  final VoidCallback onConfirmExit;

  const ExamExitDialog({
    super.key,
    required this.onConfirmExit,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirmExit}) {
    return showAppDialog(
      context: context,
      builder: (_) => ExamExitDialog(onConfirmExit: onConfirmExit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      icon: Icons.warning_amber_rounded,
      iconColor: AppColors.error,
      iconBackgroundColor: AppColors.errorContainer,
      title: 'Dừng bài thi?',
      message: 'Bài làm của bạn đang dở dang và sẽ không được lưu vào lịch sử nếu thoát ngay bây giờ.',
      cancelText: 'Tiếp tục làm',
      confirmText: 'Thoát bài thi',
      isDestructive: true,
      onConfirm: onConfirmExit,
    );
  }
}
