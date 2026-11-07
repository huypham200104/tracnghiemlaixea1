import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_dialog.dart';

/// Dialog xác nhận trước khi bắt đầu bài thi sát hạch (Modern Material 3)
class ExamStartDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ExamStartDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showAppDialog(
      context: context,
      builder: (_) => ExamStartDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      icon: Icons.quiz_rounded,
      iconColor: AppColors.primary,
      iconBackgroundColor: AppColors.primaryContainer,
      title: 'Bắt đầu thi sát hạch?',
      cancelText: 'Để sau',
      confirmText: 'Bắt đầu làm bài',
      onConfirm: onConfirm,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Thẻ tóm tắt thể thức bài thi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.format_list_numbered_rounded,
                  label: 'Số lượng câu hỏi',
                  value: '${AppConstants.examQuestionCount} câu ngẫu nhiên',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColors.divider, height: 1),
                ),
                _buildInfoRow(
                  icon: Icons.timer_outlined,
                  label: 'Thời gian làm bài',
                  value: '${AppConstants.examDurationMinutes} phút',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColors.divider, height: 1),
                ),
                _buildInfoRow(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Yêu cầu vượt qua',
                  value: '≥ ${AppConstants.passingScore}/${AppConstants.examQuestionCount} câu',
                  valueColor: AppColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Lưu ý câu điểm liệt
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_rounded,
                  color: AppColors.error,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lưu ý: Làm sai bất kỳ câu điểm liệt nào sẽ bị kết luận KHÔNG ĐẠT ngay lập tức.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          textAlign: TextAlign.end,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
