import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../study/domain/question_model.dart';

/// Modal Bottom Sheet hiển thị ma trận 25 câu hỏi của bài thi sát hạch
class ExamGridSheet extends StatelessWidget {
  final List<Question> questions;
  final int currentIndex;
  final bool Function(int index) isAnswered;
  final bool Function(int questionId) isBookmarked;
  final ValueChanged<int> onSelectQuestion;

  const ExamGridSheet({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.isAnswered,
    required this.isBookmarked,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title & Status Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách 25 câu hỏi',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  _buildLegendItem(AppColors.primary, 'Đã làm'),
                  const SizedBox(width: 10),
                  _buildLegendItem(AppColors.canvas, 'Chưa làm', borderColor: AppColors.border),
                  const SizedBox(width: 10),
                  _buildLegendItem(AppColors.error, 'Điểm liệt'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 5-Column Grid of 25 Question Cells
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final q = questions[index];
                final answered = isAnswered(index);
                final isCurrent = index == currentIndex;
                final bookmarked = isBookmarked(q.id);

                Color bg = answered ? AppColors.primary : AppColors.canvas;
                Color fg = answered ? Colors.white : AppColors.textPrimary;
                Color border = isCurrent ? AppColors.warning : AppColors.border;

                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelectQuestion(index);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: border,
                        width: isCurrent ? 2.5 : 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${index + 1}',
                          style: AppTypography.labelLarge.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Điểm đỏ câu điểm liệt ở góc phải trên
                        if (q.isCritical)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        // Icon bookmark ở góc trái trên
                        if (bookmarked)
                          const Positioned(
                            top: 2,
                            left: 2,
                            child: Icon(
                              Icons.bookmark,
                              size: 10,
                              color: AppColors.warning,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {Color? borderColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
