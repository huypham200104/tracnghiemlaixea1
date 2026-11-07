import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_dialog.dart';

/// Dialog cài đặt ứng dụng (Modern Material 3 Content Dialog)
class AppSettingsDialog extends StatelessWidget {
  final String fontSize;
  final bool soundEnabled;
  final ValueChanged<String> onFontSizeChanged;
  final ValueChanged<bool> onSoundEnabledChanged;
  final VoidCallback onRequestResetData;

  const AppSettingsDialog({
    super.key,
    required this.fontSize,
    required this.soundEnabled,
    required this.onFontSizeChanged,
    required this.onSoundEnabledChanged,
    required this.onRequestResetData,
  });

  static Future<void> show(
    BuildContext context, {
    required String fontSize,
    required bool soundEnabled,
    required ValueChanged<String> onFontSizeChanged,
    required ValueChanged<bool> onSoundEnabledChanged,
    required VoidCallback onRequestResetData,
  }) {
    return showAppDialog(
      context: context,
      builder: (_) => AppSettingsDialog(
        fontSize: fontSize,
        soundEnabled: soundEnabled,
        onFontSizeChanged: onFontSizeChanged,
        onSoundEnabledChanged: onSoundEnabledChanged,
        onRequestResetData: onRequestResetData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContentDialog(
      icon: Icons.tune_rounded,
      iconColor: AppColors.primary,
      iconBackgroundColor: AppColors.primaryContainer,
      title: 'Cài đặt ứng dụng',
      subtitle: 'Tùy chỉnh giao diện và dữ liệu cá nhân',
      maxWidth: 460,
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mục cỡ chữ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cỡ chữ câu hỏi',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  fontSize == 'small'
                      ? 'Nhỏ (15sp)'
                      : fontSize == 'large'
                          ? 'Lớn (19sp)'
                          : 'Vừa (17sp)',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'small', label: Text('Nhỏ')),
                  ButtonSegment(value: 'medium', label: Text('Vừa')),
                  ButtonSegment(value: 'large', label: Text('Lớn')),
                ],
                selected: {fontSize},
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                onSelectionChanged: (val) {
                  onFontSizeChanged(val.first);
                },
              ),
            ),
            const SizedBox(height: 18),

            // Mục âm thanh & rung
            Container(
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
              child: SwitchListTile(
                title: Text(
                  'Âm thanh & Rung',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Phát âm báo khi nộp bài hoặc cảnh báo',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                value: soundEnabled,
                activeColor: AppColors.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                onChanged: onSoundEnabledChanged,
              ),
            ),
            const SizedBox(height: 14),

            // Mục đặt lại dữ liệu
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.of(context).pop();
                onRequestResetData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_sweep_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đặt lại toàn bộ dữ liệu',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Xóa sạch lịch sử thi, câu sai và bookmark',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          child: const Text('Hoàn tất'),
        ),
      ],
    );
  }
}
