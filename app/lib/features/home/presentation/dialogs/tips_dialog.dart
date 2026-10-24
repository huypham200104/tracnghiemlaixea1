import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog hiển thị các mẹo ghi nhớ nhanh khi thi sát hạch A1
class TipsDialog extends StatelessWidget {
  const TipsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const TipsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, color: AppColors.warning),
          const SizedBox(width: 8),
          Text(
            'Mẹo thi A1 cần nhớ',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipItem(
              '1. Câu điểm liệt:',
              'Tuyệt đối không chọn các đáp án cho phép: uống rượu bia, dùng ma túy, chạy quá tốc độ, vượt trên cầu hẹp 1 làn, sử dụng điện thoại khi lái xe.',
            ),
            const SizedBox(height: 10),
            _buildTipItem(
              '2. Thứ tự xe ưu tiên:',
              'Hỏa (Cứu hỏa) -> Sự (Quân sự) -> An (Công an) -> Thương (Cứu thương) -> Đê/Tang.',
            ),
            const SizedBox(height: 10),
            _buildTipItem(
              '3. Hướng ưu tiên tại ngã tư:',
              'Xe rẽ phải đi trước -> Xe đi thẳng đi tiếp theo -> Xe rẽ trái đi sau cùng.',
            ),
            const SizedBox(height: 10),
            _buildTipItem(
              '4. Vòng số 8 thực hành:',
              'Đi số 2 hoặc số 3 để xe chạy đầm, giữ đều ga, không bóp phanh trước trong cua.',
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Đã hiểu'),
        ),
      ],
    );
  }

  Widget _buildTipItem(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
