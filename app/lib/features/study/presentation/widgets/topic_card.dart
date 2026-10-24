import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/topic_model.dart';

/// Thẻ hiển thị một chương ôn tập lý thuyết A1 (SRP)
class TopicCard extends StatelessWidget {
  final Topic topic;
  final int questionsCount;
  final int completedCount;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    required this.questionsCount,
    this.completedCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${topic.id}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.name,
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.description,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (completedCount > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: questionsCount > 0 ? (completedCount / questionsCount).clamp(0.0, 1.0) : 0.0,
                          minHeight: 5,
                          backgroundColor: AppColors.canvas,
                          color: completedCount >= questionsCount ? AppColors.success : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Đã làm: $completedCount/$questionsCount câu',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: completedCount >= questionsCount ? AppColors.success : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (topic.criticalQuestionsCount > 0)
                            Text(
                              '${topic.criticalQuestionsCount} câu liệt',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '$questionsCount câu hỏi',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (topic.criticalQuestionsCount > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '(${topic.criticalQuestionsCount} câu điểm liệt)',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
