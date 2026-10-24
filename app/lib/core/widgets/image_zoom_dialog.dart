import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Hộp thoại phóng to ảnh hỗ trợ vuốt, thu phóng đa điểm (InteractiveViewer)
class ImageZoomDialog extends StatelessWidget {
  final String imagePath;
  final String? title;

  const ImageZoomDialog({
    super.key,
    required this.imagePath,
    this.title,
  });

  /// Tiện ích hiển thị dialog phóng to ảnh
  static Future<void> show(BuildContext context, {required String imagePath, String? title}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => ImageZoomDialog(
        imagePath: imagePath,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vùng thu phóng ảnh
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: AppColors.surface,
              constraints: const BoxConstraints(
                maxHeight: 520,
                maxWidth: 480,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image, size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              title!,
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Flexible(
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 260,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.broken_image_outlined,
                                  size: 64,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Hình minh họa tình huống',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  imagePath,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Dùng 2 ngón tay để phóng to / thu nhỏ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nút đóng ở góc trên bên phải
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 22),
                tooltip: 'Đóng',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
