import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/image_zoom_dialog.dart';
import '../../../../core/widgets/traffic_sign_avatar.dart';
import '../../domain/traffic_sign_model.dart';

/// Modal dialog chi tiết biển báo giao thông (SRP)
class TrafficSignDetailDialog extends StatelessWidget {
  final TrafficSign sign;

  const TrafficSignDetailDialog({
    super.key,
    required this.sign,
  });

  static Future<void> show(BuildContext context, TrafficSign sign) {
    return showDialog(
      context: context,
      builder: (_) => TrafficSignDetailDialog(sign: sign),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              sign.code,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              sign.name,
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Đồ họa nhận diện biển báo
            GestureDetector(
              onTap: sign.image != null
                  ? () => ImageZoomDialog.show(
                        context,
                        imagePath: sign.image!,
                        title: '${sign.code}: ${sign.name}',
                      )
                  : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    TrafficSignAvatar(sign: sign, size: 84),
                    if (sign.image != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Chạm để phóng to ảnh',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      sign.groupName,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (sign.isInExam)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.warningContainer,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 13, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            'Có trong đề thi A1',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ý nghĩa biển báo:',
                style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                sign.description,
                style: AppTypography.bodyMedium.copyWith(height: 1.4),
              ),
            ),
            if (sign.tips != null && sign.tips!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFB300), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 18,
                          color: Color(0xFFE65100),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Lưu ý thi A1 & Mẹo ghi nhớ',
                          style: AppTypography.labelLarge.copyWith(
                            color: const Color(0xFFBF360C),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sign.tips!,
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF3E2723),
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}
