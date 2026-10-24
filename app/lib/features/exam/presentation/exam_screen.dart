import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/timer_widget.dart';
import '../../../../core/widgets/question_card.dart';
import '../state/exam_provider.dart';
import '../../profile/state/user_data_provider.dart';
import 'exam_coordinator.dart';
import 'exam_result_screen.dart';

/// Màn hình làm bài thi sát hạch 25 câu / 19 phút (SRP & DIP)
class ExamScreen extends StatefulWidget {
  final ExamCoordinator coordinator;

  const ExamScreen({
    super.key,
    this.coordinator = const ExamCoordinator(),
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = context.watch<ExamProvider>();
    final userDataProvider = context.watch<UserDataProvider>();
    final questions = examProvider.questions;

    // Tự động chuyển màn hình khi hết giờ và hệ thống tự nộp
    if (examProvider.isSubmitted && examProvider.latestResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ExamResultScreen(result: examProvider.latestResult!),
          ),
        );
      });
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(title: const Text('Thi sát hạch')),
        body: const Center(child: Text('Không có câu hỏi thi.')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          widget.coordinator.handleConfirmExit(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Thoát bài thi',
            onPressed: () => widget.coordinator.handleConfirmExit(context),
          ),
          title: TimerWidget(remainingSeconds: examProvider.remainingSeconds),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              tooltip: 'Danh sách 25 câu',
              onPressed: () => widget.coordinator.showGridSheet(
                context,
                pageController: _pageController,
              ),
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: questions.length,
          onPageChanged: (index) {
            examProvider.goToQuestion(index);
          },
          itemBuilder: (context, index) {
            final q = questions[index];
            final selected = examProvider.getAnswerForQuestion(q.id);

            return QuestionCard(
              question: q,
              selectedIndex: selected,
              isReviewMode: false,
              questionNumber: index + 1,
              totalQuestions: questions.length,
              isBookmarked: userDataProvider.isBookmarked(q.id),
              onToggleBookmark: () => userDataProvider.toggleBookmark(q.id),
              onSelectOption: (optionIndex) {
                examProvider.selectAnswerForQuestion(q.id, optionIndex);
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'Câu trước',
                    onPressed: examProvider.currentIndex > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    tooltip: 'Câu sau',
                    onPressed: examProvider.currentIndex < questions.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => widget.coordinator.handleConfirmSubmit(context),
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: Text(
                        'Nộp bài (${examProvider.answeredCount}/${questions.length})',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
