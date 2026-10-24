import 'package:flutter/material.dart';
import '../../features/study/domain/question_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'image_zoom_dialog.dart';
import 'status_badge.dart';

/// Thẻ hiển thị nội dung câu hỏi và các lựa chọn đáp án A, B, C, D
class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedIndex;
  final ValueChanged<int>? onSelectOption;
  final bool isReviewMode;
  final int questionNumber;
  final int totalQuestions;
  final VoidCallback? onToggleBookmark;
  final bool isBookmarked;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedIndex,
    this.onSelectOption,
    this.isReviewMode = false,
    required this.questionNumber,
    required this.totalQuestions,
    this.onToggleBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Số câu, Badge Điểm liệt, Bookmark
          Row(
            children: [
              Text(
                'Câu $questionNumber/$totalQuestions',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              if (question.isCritical) StatusBadge.critical(),
              const Spacer(),
              if (onToggleBookmark != null)
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.warning : AppColors.textSecondary,
                  ),
                  onPressed: onToggleBookmark,
                  tooltip: 'Đánh dấu câu hỏi',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Nội dung câu hỏi
          Text(
            question.content,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),

          // Hình ảnh minh họa (nếu có: biển báo / sa hình)
          if (question.image != null && question.image!.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                ImageZoomDialog.show(
                  context,
                  imagePath: question.image!,
                  title: 'Câu $questionNumber: Hình ảnh minh họa',
                );
              },
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        question.image!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Hình minh họa tình huống',
                                  style: AppTypography.labelLarge.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  question.image!,
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
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Chạm để phóng to',
                                style: TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Danh sách các lựa chọn đáp án (A, B, C, D)
          ...List.generate(question.options.length, (index) {
            final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
            final optionText = question.options[index];
            final isSelected = selectedIndex == index;
            final isCorrect = question.correctIndex == index;

            Color bgColor = AppColors.surface;
            Color borderColor = AppColors.border;
            Color letterBg = AppColors.canvas;
            Color letterFg = AppColors.textSecondary;
            Widget? trailingIcon;

            if (isReviewMode) {
              if (isCorrect) {
                bgColor = AppColors.successContainer;
                borderColor = AppColors.success;
                letterBg = AppColors.success;
                letterFg = Colors.white;
                trailingIcon = const Icon(Icons.check_circle, color: AppColors.success);
              } else if (isSelected && !isCorrect) {
                bgColor = AppColors.errorContainer;
                borderColor = AppColors.error;
                letterBg = AppColors.error;
                letterFg = Colors.white;
                trailingIcon = const Icon(Icons.cancel, color: AppColors.error);
              }
            } else {
              if (isSelected) {
                bgColor = AppColors.primaryContainer;
                borderColor = AppColors.primary;
                letterBg = AppColors.primary;
                letterFg = Colors.white;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: isReviewMode ? null : () => onSelectOption?.call(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                      width: isSelected || (isReviewMode && isCorrect) ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vòng tròn ký tự A, B, C, D
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: letterBg,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          optionLetter,
                          style: AppTypography.labelLarge.copyWith(
                            color: letterFg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Nội dung đáp án
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            optionText,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        trailingIcon,
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          // Khung giải thích chi tiết trong chế độ ôn tập/xem lại
          if (isReviewMode && question.explanation.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warningContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb, size: 18, color: AppColors.warning),
                      const SizedBox(width: 6),
                      Text(
                        'Giải thích đáp án:',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question.explanation,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
