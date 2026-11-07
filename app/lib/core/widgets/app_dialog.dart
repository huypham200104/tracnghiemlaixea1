import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Helper mở dialog với hiệu ứng Fade + Scale nhẹ nhàng chuẩn Material 3
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, anim1, anim2) => builder(ctx),
    transitionBuilder: (ctx, anim1, anim2, child) {
      final curvedValue = Curves.easeOut.transform(anim1.value);
      return Transform.scale(
        scale: 0.95 + (0.05 * curvedValue),
        child: Opacity(
          opacity: anim1.value,
          child: child,
        ),
      );
    },
  );
}

/// Dialog xác nhận thao tác chuẩn hóa (Modern Material 3 Confirmation Dialog)
/// Huy hiệu icon tròn căn giữa, tiêu đề, mô tả và hàng nút bấm side-by-side
class AppConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const AppConfirmDialog({
    super.key,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBackgroundColor = AppColors.primaryContainer,
    required this.title,
    this.message,
    this.content,
    required this.confirmText,
    this.cancelText = 'Hủy',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width > 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border, width: 0.8),
      ),
      elevation: 3,
      backgroundColor: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet
            ? ((mediaQuery.size.width - 420) / 2).clamp(24.0, double.infinity)
            : 20,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: mediaQuery.size.height * 0.88,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Huy hiệu icon tròn căn giữa nổi bật (56x56dp)
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: iconBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(icon, color: iconColor, size: 30),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Tiêu đề căn giữa
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      // Nội dung mô tả text
                      if (message != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          message!,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],

                      // Nội dung widget bổ sung (nếu có)
                      if (content != null) ...[
                        const SizedBox(height: 14),
                        content!,
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Hàng nút thao tác side-by-side
              Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onCancel?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: AppColors.border, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          foregroundColor: AppColors.textPrimary,
                          backgroundColor: AppColors.canvas,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          cancelText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: isDestructive ? AppColors.error : iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        confirmText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog nội dung & cài đặt chuẩn hóa (Modern Material 3 Content Dialog)
/// Header ngang với icon squircle, tiêu đề và nút đóng (X)
class AppContentDialog extends StatelessWidget {
  final Widget? leadingIcon;
  final IconData? icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showCloseButton;
  final Widget body;
  final List<Widget>? actions;
  final double maxWidth;
  final double maxHeightFactor;
  final EdgeInsetsGeometry contentPadding;

  const AppContentDialog({
    super.key,
    this.leadingIcon,
    this.icon,
    this.iconColor = AppColors.primary,
    this.iconBackgroundColor = AppColors.primaryContainer,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showCloseButton = true,
    required this.body,
    this.actions,
    this.maxWidth = 520,
    this.maxHeightFactor = 0.85,
    this.contentPadding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width > 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border, width: 0.8),
      ),
      elevation: 3,
      backgroundColor: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet
            ? ((mediaQuery.size.width - maxWidth) / 2).clamp(24.0, double.infinity)
            : 16,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: mediaQuery.size.height * maxHeightFactor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header thanh lịch
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 14),
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    leadingIcon!,
                    const SizedBox(width: 12),
                  ] else if (icon != null) ...[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(icon, color: iconColor, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                  if (showCloseButton) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.canvas,
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(36, 36),
                      ),
                      icon: const Icon(Icons.close_rounded, size: 20),
                      tooltip: 'Đóng',
                    ),
                  ],
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),

            // Thân nội dung
            Flexible(
              child: Padding(
                padding: contentPadding,
                child: body,
              ),
            ),

            // Hàng actions nếu có
            if (actions != null && actions!.isNotEmpty) ...[
              const Divider(color: AppColors.divider, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
