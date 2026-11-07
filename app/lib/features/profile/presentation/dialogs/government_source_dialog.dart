import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_dialog.dart';

/// Dialog hiển thị nguồn dữ liệu chính phủ (.gov.vn) và tuyên bố miễn trừ trách nhiệm
/// Tuân thủ chính sách Google Play "Misleading Claims / Government Apps"
class GovernmentSourceDialog extends StatelessWidget {
  const GovernmentSourceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showAppDialog(
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
    return AppContentDialog(
      icon: Icons.policy_rounded,
      iconColor: AppColors.primary,
      iconBackgroundColor: AppColors.primaryContainer,
      title: 'Nguồn dữ liệu & Pháp lý',
      subtitle: 'Minh bạch nguồn thông tin & Miễn trừ trách nhiệm',
      maxWidth: 480,
      contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Khối cảnh báo miễn trừ trách nhiệm
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Tuyên bố miễn trừ trách nhiệm',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
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

            // 2. Nguồn tham khảo chính thức
            Text(
              'Nguồn thông tin chính phủ (.gov.vn):',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toàn bộ 200 câu hỏi sát hạch và hệ thống biển báo được tham khảo công khai từ các cổng thông tin điện tử chính thức:',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),

            // 3. Danh sách nguồn
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
              description:
                  'Luật Giao thông đường bộ & Quy chuẩn kỹ thuật QCVN 41:2019/BGTVT',
              url: 'https://chinhphu.vn',
            ),
          ],
        ),
      ),
      actions: [
        Expanded(
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.link_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
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
            icon: const Icon(
              Icons.copy_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
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
