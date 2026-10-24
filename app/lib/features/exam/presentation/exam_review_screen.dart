import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/question_card.dart';
import '../../profile/state/user_data_provider.dart';
import '../../study/domain/question_model.dart';

/// Màn hình xem lại chi tiết 25 câu hỏi của bài thi đã làm
class ExamReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int?> userAnswers;

  const ExamReviewScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Xem lại bài thi'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final q = questions[index];
            final selected = userAnswers[q.id];

            return Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: QuestionCard(
                question: q,
                selectedIndex: selected,
                isReviewMode: true, // Hiển thị đáp án đúng và giải thích
                questionNumber: index + 1,
                totalQuestions: questions.length,
                isBookmarked: userDataProvider.isBookmarked(q.id),
                onToggleBookmark: () => userDataProvider.toggleBookmark(q.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
