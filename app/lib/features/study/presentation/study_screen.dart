import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../domain/question_model.dart';
import '../state/study_provider.dart';
import 'study_session_screen.dart';
import 'widgets/topic_card.dart';

/// Màn hình Ôn tập theo chương (Tab 2) — Clean, Modern Material 3
class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  void _openStudySession(
    BuildContext context, {
    required String title,
    required List<Question> questions,
    int? topicId,
  }) {
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có câu hỏi nào trong mục này.')),
      );
      return;
    }

    final studyProvider = context.read<StudyProvider>();
    final answeredQuestionIds = <int>{};

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudySessionScreen(
          title: title,
          questions: questions,
          isReviewModeImmediately: true,
          onAnswerSelected: topicId != null
              ? (qId, optIdx) {
                  answeredQuestionIds.add(qId);
                  final currentCompleted = studyProvider.getTopicCompletedCount(topicId);
                  if (answeredQuestionIds.length > currentCompleted) {
                    studyProvider.updateTopicProgress(topicId, answeredQuestionIds.length);
                  }
                }
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = context.watch<StudyProvider>();
    final topics = studyProvider.topics;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Ôn tập theo chương'),
        elevation: 0,
      ),
      body: studyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Khối Chuyên đề 20 Câu điểm liệt
                _buildCriticalTopicCard(context, studyProvider),
                const SizedBox(height: 20),

                Text(
                  '5 Chương lý thuyết A1',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),

                // Danh sách 5 chương qua TopicCard (SRP)
                ...topics.map((topic) {
                  final topicQuestions = studyProvider.getQuestionsByTopic(topic.id);
                  final completedCount = studyProvider.getTopicCompletedCount(topic.id);
                  return TopicCard(
                    topic: topic,
                    questionsCount: topicQuestions.length,
                    completedCount: completedCount,
                    onTap: () {
                      _openStudySession(
                        context,
                        title: 'Chương ${topic.id}: ${topic.name}',
                        questions: topicQuestions,
                        topicId: topic.id,
                      );
                    },
                  );
                }),
              ],
            ),
    );
  }

  Widget _buildCriticalTopicCard(BuildContext context, StudyProvider studyProvider) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '20 CÂU ĐIỂM LIỆT BẮT BUỘC',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'QUAN TRỌNG',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tổng hợp toàn bộ các tình huống mất an toàn giao thông nghiêm trọng. Sai 1 câu là TRƯỢT ngay bài thi sát hạch.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final criticalList = studyProvider.criticalQuestions;
                _openStudySession(
                  context,
                  title: 'Luyện 20 câu điểm liệt',
                  questions: criticalList,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Bắt đầu luyện 20 câu điểm liệt',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
