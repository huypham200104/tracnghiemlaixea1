import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog xác nhận đặt lại toàn bộ dữ liệu người dùng (SRP)
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 36),
      title: const Text(
        'Đặt lại toàn bộ dữ liệu?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: const Text(
        'Toàn bộ lịch sử thi sát hạch, tiến độ học các chương, câu đánh dấu và sổ tay câu sai sẽ bị xóa sạch.\n\nThao tác này không thể hoàn tác.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmReset();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Đặt lại tất cả'),
        ),
      ],
    );
  }
}
