import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../domain/question_model.dart';
import '../state/study_provider.dart';
import 'study_session_screen.dart';
import 'widgets/topic_card.dart';

/// Màn hình Ôn tập theo chương (Tab 2) — Tuân thủ SRP, OCP, LSP
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
                const SizedBox(height: 18),

                Text(
                  '5 Chương lý thuyết A1',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '20 CÂU ĐIỂM LIỆT',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Cực kỳ quan trọng · Sai 1 câu là TRƯỢT ngay',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final criticalList = studyProvider.criticalQuestions;
                _openStudySession(
                  context,
                  title: 'Luyện 20 câu điểm liệt',
                  questions: criticalList,
                );
              },
              icon: const Icon(Icons.school, size: 18),
              label: const Text('Luyện câu điểm liệt ngay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
