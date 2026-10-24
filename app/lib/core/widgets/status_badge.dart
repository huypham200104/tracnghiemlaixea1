import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum BadgeType { success, error, warning, info, critical }

/// Badge trạng thái (ĐẠT / TRƯỢT / CÂU ĐIỂM LIỆT)
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.info,
    this.icon,
  });

  factory StatusBadge.passed() {
    return const StatusBadge(
      label: 'ĐẠT',
      type: BadgeType.success,
      icon: Icons.check_circle,
    );
  }

  factory StatusBadge.failed() {
    return const StatusBadge(
      label: 'TRƯỢT',
      type: BadgeType.error,
      icon: Icons.cancel,
    );
  }

  factory StatusBadge.critical() {
    return const StatusBadge(
      label: 'CÂU ĐIỂM LIỆT',
      type: BadgeType.critical,
      icon: Icons.warning_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.success:
        bg = AppColors.successContainer;
        fg = AppColors.success;
        break;
      case BadgeType.error:
        bg = AppColors.errorContainer;
        fg = AppColors.error;
        break;
      case BadgeType.warning:
        bg = AppColors.warningContainer;
        fg = AppColors.warning;
        break;
      case BadgeType.critical:
        bg = AppColors.errorContainer;
        fg = AppColors.error;
        break;
      case BadgeType.info:
        bg = AppColors.primaryContainer;
        fg = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: fg.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
