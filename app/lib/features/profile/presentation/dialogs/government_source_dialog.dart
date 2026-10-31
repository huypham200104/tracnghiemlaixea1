import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog hiển thị nguồn dữ liệu chính phủ (.gov.vn) và tuyên bố miễn trừ trách nhiệm
/// Tuân thủ chính sách Google Play "Misleading Claims / Government Apps"
class GovernmentSourceDialog extends StatelessWidget {
  const GovernmentSourceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const GovernmentSourceDialog(),
    );
  }

  void _copyToClipboard(BuildContext context, String url, String label) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép liên kết $label: $url'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.policy_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nguồn dữ liệu & Pháp lý',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Disclaimer box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.error),
                      const SizedBox(width: 6),
                      Text(
                        'Tuyên bố miễn trừ trách nhiệm',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ứng dụng này là công cụ học tập và ôn thi độc lập, KHÔNG ĐẠI DIỆN VÀ KHÔNG LIÊN KẾT VỚI BẤT KỲ CƠ QUAN CHÍNH PHỦ NÀO (bao gồm Bộ Giao thông Vận tải hoặc Cục Đường bộ Việt Nam).',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Official Government Sources header
            Text(
              'Nguồn thông tin chính phủ (.gov.vn):',
              style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Toàn bộ 200 câu hỏi sát hạch và hệ thống biển báo được tham khảo công khai từ các cổng thông tin điện tử chính thức:',
              style: AppTypography.bodySmall.copyWith(height: 1.3),
            ),
            const SizedBox(height: 10),

            // 3. Source items
            _buildSourceItem(
              context,
              title: 'Cổng Dịch vụ công Quốc gia',
              description: 'Thủ tục hành chính, cấp đổi & quản lý GPLX toàn quốc',
              url: 'https://dichvucong.gov.vn',
            ),
            const SizedBox(height: 8),
            _buildSourceItem(
              context,
              title: 'Cổng Thông tin điện tử Chính phủ',
              description: 'Luật Giao thông đường bộ & Quy chuẩn kỹ thuật QCVN 41:2019/BGTVT',
              url: 'https://chinhphu.vn',
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Đã hiểu'),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceItem(
    BuildContext context, {
    required String title,
    required String description,
    required String url,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.link, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  url,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_outlined, size: 18, color: AppColors.textSecondary),
            tooltip: 'Sao chép liên kết',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => _copyToClipboard(context, url, title),
          ),
        ],
      ),
    );
  }
}
