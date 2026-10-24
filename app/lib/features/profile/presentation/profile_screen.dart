import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/status_badge.dart';
import '../state/user_data_provider.dart';
import '../../study/state/study_provider.dart';
import '../../study/domain/question_model.dart';
import '../../study/presentation/study_session_screen.dart';
import 'dialogs/reset_data_confirm_dialog.dart';

/// Màn hình Của tôi (Tab 4) — Tuân thủ SRP, OCP, LSP
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _openStudySession(
    BuildContext context, {
    required String title,
    required List<Question> questions,
  }) {
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Danh sách đang trống.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StudySessionScreen(
          title: title,
          questions: questions,
          isReviewModeImmediately: true,
        ),
      ),
    );
  }

  void _confirmResetData(BuildContext context) {
    final userDataProvider = context.read<UserDataProvider>();
    final studyProvider = context.read<StudyProvider>();

    ResetDataConfirmDialog.show(
      context,
      onConfirmReset: () async {
        await userDataProvider.resetAllData();
        await studyProvider.resetProgress();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã đặt lại toàn bộ dữ liệu thành công.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final studyProvider = context.watch<StudyProvider>();

    final wrongQuestions =
        studyProvider.getQuestionsByIds(userDataProvider.wrongQuestionIds);
    final bookmarkedQuestions =
        studyProvider.getQuestionsByIds(userDataProvider.bookmarkedIds);
    final examHistory = userDataProvider.examHistory;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Của tôi'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Đặt lại dữ liệu',
            onPressed: () => _confirmResetData(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Thẻ Sổ tay câu sai (tái sử dụng StudySessionScreen)
          _buildMenuCard(
            context,
            icon: Icons.cancel_outlined,
            iconColor: AppColors.error,
            bgColor: AppColors.errorContainer,
            title: 'Sổ tay câu làm sai',
            subtitle: '${wrongQuestions.length} câu đã trả lời sai',
            badgeText: wrongQuestions.isNotEmpty ? '${wrongQuestions.length}' : null,
            badgeColor: AppColors.error,
            onTap: () => _openStudySession(
              context,
              title: 'Sổ tay câu làm sai',
              questions: wrongQuestions,
            ),
          ),
          const SizedBox(height: 12),

          // Thẻ Câu đã đánh dấu (tái sử dụng StudySessionScreen)
          _buildMenuCard(
            context,
            icon: Icons.bookmark_border,
            iconColor: AppColors.warning,
            bgColor: AppColors.warningContainer,
            title: 'Câu đã đánh dấu',
            subtitle: '${bookmarkedQuestions.length} câu đã lưu lại để ôn',
            badgeText: bookmarkedQuestions.isNotEmpty ? '${bookmarkedQuestions.length}' : null,
            badgeColor: AppColors.warning,
            onTap: () => _openStudySession(
              context,
              title: 'Câu đã đánh dấu',
              questions: bookmarkedQuestions,
            ),
          ),
          const SizedBox(height: 20),

          // Lịch sử thi sát hạch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch sử thi sát hạch',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (examHistory.isNotEmpty)
                TextButton(
                  onPressed: () => userDataProvider.clearExamHistory(),
                  child: Text(
                    'Xóa lịch sử',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (examHistory.isEmpty)
            _buildEmptyHistoryCard()
          else
            ...examHistory.map((item) => _buildExamHistoryItem(item)),

          const SizedBox(height: 24),

          // Thông tin ứng dụng
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Trắc Nghiệm Lái Xe A1 · v1.0.0',
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bộ 200 câu hỏi chuẩn Cục Đường bộ Việt Nam\nHoạt động 100% Offline',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.history, size: 40, color: AppColors.textDisabled),
            const SizedBox(height: 8),
            Text(
              'Chưa có bài thi nào',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Hãy làm bài thi sát hạch để hệ thống lưu lịch sử và đánh giá kết quả.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamHistoryItem(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            item.isPassed ? StatusBadge.passed() : StatusBadge.failed(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đúng ${item.score}/${item.totalQuestions} câu',
                    style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.formattedDate} · Làm trong ${item.formattedDuration}',
                    style: AppTypography.bodySmall,
                  ),
                  if (item.isCriticalFailed) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Trượt do sai câu điểm liệt',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
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
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
