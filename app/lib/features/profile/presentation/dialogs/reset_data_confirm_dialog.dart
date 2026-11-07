import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_dialog.dart';

/// Dialog xác nhận đặt lại toàn bộ dữ liệu người dùng (Modern Material 3)
class ResetDataConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirmReset;

  const ResetDataConfirmDialog({
    super.key,
    required this.onConfirmReset,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirmReset}) {
    return showAppDialog(
      context: context,
      builder: (_) => ResetDataConfirmDialog(onConfirmReset: onConfirmReset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      icon: Icons.delete_forever_rounded,
      iconColor: AppColors.error,
      iconBackgroundColor: AppColors.errorContainer,
      title: 'Đặt lại toàn bộ dữ liệu?',
      message:
          'Toàn bộ lịch sử thi sát hạch, tiến độ học các chương, câu đánh dấu và sổ tay câu sai sẽ bị xóa vĩnh viễn khỏi thiết bị.\n\nThao tác này không thể hoàn tác.',
      cancelText: 'Hủy',
      confirmText: 'Đặt lại tất cả',
      isDestructive: true,
      onConfirm: onConfirmReset,
    );
  }
}
