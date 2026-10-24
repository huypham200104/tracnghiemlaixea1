import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/exam_model.dart';
import '../state/exam_provider.dart';
import '../../study/state/study_provider.dart';
import '../../profile/state/user_data_provider.dart';
import 'dialogs/exam_exit_dialog.dart';
import 'dialogs/exam_submit_dialog.dart';
import 'widgets/exam_grid_sheet.dart';
import 'exam_result_screen.dart';
import 'exam_review_screen.dart';
import 'exam_screen.dart';

/// Coordinator xử lý logic điều hướng và hộp thoại xác nhận cho luồng Thi sát hạch (DIP & SRP)
class ExamCoordinator {
  const ExamCoordinator();

  void handleConfirmExit(BuildContext context) {
    ExamExitDialog.show(
      context,
      onConfirmExit: () {
        context.read<ExamProvider>().cancelExam();
        Navigator.of(context).pop();
      },
    );
  }

  void handleConfirmSubmit(BuildContext context) {
    final examProvider = context.read<ExamProvider>();
    ExamSubmitDialog.show(
      context,
      unansweredCount: examProvider.unansweredCount,
      onConfirmSubmit: () => submitAndNavigateToResult(context),
    );
  }

  void submitAndNavigateToResult(BuildContext context) {
    final examProvider = context.read<ExamProvider>();
    final result = examProvider.submitExam();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExamResultScreen(result: result),
      ),
    );
  }

  void showGridSheet(BuildContext context, {required PageController pageController}) {
    final examProvider = context.read<ExamProvider>();
    final userDataProvider = context.read<UserDataProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExamGridSheet(
        questions: examProvider.questions,
        currentIndex: examProvider.currentIndex,
        isAnswered: examProvider.isQuestionAnswered,
        isBookmarked: userDataProvider.isBookmarked,
        onSelectQuestion: (index) {
          examProvider.goToQuestion(index);
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  void handleReviewExam(BuildContext context, ExamResult result) {
    final examProvider = context.read<ExamProvider>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExamReviewScreen(
          questions: examProvider.questions,
          userAnswers: result.answers,
        ),
      ),
    );
  }

  void handleRetakeExam(BuildContext context) {
    final examProvider = context.read<ExamProvider>();
    final studyProvider = context.read<StudyProvider>();

    examProvider.startExam(studyProvider.questions);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ExamScreen(),
      ),
    );
  }

  void handleNavigateHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
