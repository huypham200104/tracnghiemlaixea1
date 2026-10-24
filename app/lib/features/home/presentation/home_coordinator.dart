import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dialogs/tips_dialog.dart';
import '../../exam/presentation/dialogs/exam_start_dialog.dart';
import '../../exam/presentation/exam_screen.dart';
import '../../exam/state/exam_provider.dart';
import '../../study/state/study_provider.dart';

/// Coordinator xử lý logic điều hướng và mở dialog cho Trang chủ (DIP)
class HomeCoordinator {
  final ValueChanged<int> onNavigateTab;

  const HomeCoordinator({required this.onNavigateTab});

  void handleStartExam(BuildContext context) {
    ExamStartDialog.show(
      context,
      onConfirm: () => _launchExamScreen(context),
    );
  }

  void _launchExamScreen(BuildContext context) {
    final studyProvider = context.read<StudyProvider>();
    final examProvider = context.read<ExamProvider>();

    if (studyProvider.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang tải câu hỏi, vui lòng thử lại...')),
      );
      return;
    }

    examProvider.startExam(studyProvider.questions);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ExamScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  void handleShowTips(BuildContext context) {
    TipsDialog.show(context);
  }

  void handleNavigateTab(int index) {
    onNavigateTab(index);
  }
}
