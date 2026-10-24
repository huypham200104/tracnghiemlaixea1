import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dialog cài đặt ứng dụng (cỡ chữ, âm thanh, đặt lại dữ liệu) (SRP)
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
    return showDialog(
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Cài đặt ứng dụng'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cỡ chữ hiển thị câu hỏi:',
            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'small', label: Text('Nhỏ')),
              ButtonSegment(value: 'medium', label: Text('Vừa')),
              ButtonSegment(value: 'large', label: Text('Lớn')),
            ],
            selected: {fontSize},
            onSelectionChanged: (val) {
              onFontSizeChanged(val.first);
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Âm thanh & Rung'),
            subtitle: const Text('Thông báo khi nộp bài và cảnh báo'),
            contentPadding: EdgeInsets.zero,
            value: soundEnabled,
            onChanged: onSoundEnabledChanged,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Đặt lại toàn bộ dữ liệu',
              style: AppTypography.labelLarge.copyWith(color: AppColors.error),
            ),
            subtitle: const Text('Xóa toàn bộ câu sai, bookmark, lịch sử thi'),
            trailing: const Icon(Icons.delete_forever, color: AppColors.error),
            onTap: () {
              Navigator.of(context).pop();
              onRequestResetData();
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Xong'),
        ),
      ],
    );
  }
}
