import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/question_card.dart';
import '../domain/question_model.dart';
import '../../profile/state/user_data_provider.dart';

/// Màn hình phiên ôn tập / giải câu hỏi dùng chung (SOLID: SRP, OCP, LSP)
class StudySessionScreen extends StatefulWidget {
  final String title;
  final List<Question> questions;
  final bool isReviewModeImmediately;
  final void Function(int questionId, int optionIndex)? onAnswerSelected;

  const StudySessionScreen({
    super.key,
    required this.title,
    required this.questions,
    this.isReviewModeImmediately = true,
    this.onAnswerSelected,
  });

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {};

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
    if (widget.questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('Không có câu hỏi trong danh sách.')),
      );
    }

    final userDataProvider = context.watch<UserDataProvider>();
    final currentQ = widget.questions[_currentIndex];
    final isBookmarked = userDataProvider.isBookmarked(currentQ.id);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (userDataProvider.isWrong(currentQ.id))
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
              tooltip: 'Bỏ khỏi sổ tay câu sai',
              onPressed: () {
                userDataProvider.removeWrongQuestion(currentQ.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa câu này khỏi Sổ tay câu sai.'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.warning : AppColors.textSecondary,
            ),
            tooltip: 'Đánh dấu câu hỏi',
            onPressed: () => userDataProvider.toggleBookmark(currentQ.id),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.questions.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final q = widget.questions[index];
          final selected = _selectedAnswers[q.id];

          return QuestionCard(
            question: q,
            selectedIndex: selected,
            isReviewMode: widget.isReviewModeImmediately && selected != null,
            questionNumber: index + 1,
            totalQuestions: widget.questions.length,
            isBookmarked: userDataProvider.isBookmarked(q.id),
            onToggleBookmark: () => userDataProvider.toggleBookmark(q.id),
            onSelectOption: (optIndex) {
              setState(() {
                _selectedAnswers[q.id] = optIndex;
              });
              widget.onAnswerSelected?.call(q.id, optIndex);

              if (optIndex != q.correctIndex) {
                userDataProvider.addWrongQuestion(q.id);
              } else {
                if (userDataProvider.isWrong(q.id)) {
                  userDataProvider.removeWrongQuestion(q.id);
                }
              }
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
                OutlinedButton.icon(
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Trước'),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_currentIndex + 1}/${widget.questions.length}',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _currentIndex < widget.questions.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Sau'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
