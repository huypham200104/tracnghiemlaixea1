import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppButtonType { primary, outlined, danger, secondary }

/// Reusable Button Widget chuẩn Material 3 và Design System
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonType type;
  final bool isFullWidth;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.type = AppButtonType.primary,
    this.isFullWidth = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonContent;

    if (isLoading) {
      buttonContent = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    Widget child;
    final minHeight = 50.0;

    switch (type) {
      case AppButtonType.primary:
        child = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.outlined:
        child = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.danger:
        child = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.onError,
            minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonContent,
        );
        break;
      case AppButtonType.secondary:
        child = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.primary,
            elevation: 0,
            minimumSize: Size(isFullWidth ? double.infinity : 0, minHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: buttonContent,
        );
        break;
    }

    return child;
  }

  Color _getTextColor() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.outlined:
      case AppButtonType.secondary:
        return AppColors.primary;
    }
  }
}
