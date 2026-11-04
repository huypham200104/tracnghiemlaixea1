import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog xác nhận đặt lại toàn bộ dữ liệu người dùng (Material 3 Native)
class ResetDataConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirmReset;

  const ResetDataConfirmDialog({
    super.key,
    required this.onConfirmReset,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirmReset}) {
    return showDialog(
      context: context,
      builder: (_) => ResetDataConfirmDialog(onConfirmReset: onConfirmReset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'Đặt lại toàn bộ dữ liệu?',
        style: AppTypography.titleLarge.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
      ),
      content: Text(
        'Toàn bộ lịch sử thi sát hạch, tiến độ học các chương, câu đánh dấu và sổ tay câu sai sẽ bị xóa vĩnh viễn khỏi thiết bị.\n\nThao tác này không thể hoàn tác.',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmReset();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Đặt lại tất cả'),
        ),
      ],
    );
  }
}
