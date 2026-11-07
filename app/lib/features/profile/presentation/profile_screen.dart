import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/status_badge.dart';
import '../state/user_data_provider.dart';
import '../../study/state/study_provider.dart';
import '../../study/domain/question_model.dart';
import '../../study/presentation/study_session_screen.dart';
import 'dialogs/reset_data_confirm_dialog.dart';
import 'dialogs/government_source_dialog.dart';

/// Màn hình Của tôi (Tab 4) — Clean, Modern Material 3
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
      body: ResponsiveContainer(
        maxWidth: 680,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
          // Thẻ Sổ tay câu sai
          _buildMenuCard(
            context,
            title: 'Sổ tay câu làm sai',
            subtitle: '${wrongQuestions.length} câu đã trả lời sai cần ôn lại',
            badgeText: wrongQuestions.isNotEmpty ? '${wrongQuestions.length}' : null,
            badgeColor: AppColors.error,
            onTap: () => _openStudySession(
              context,
              title: 'Sổ tay câu làm sai',
              questions: wrongQuestions,
            ),
          ),
          const SizedBox(height: 10),

          // Thẻ Câu đã đánh dấu
          _buildMenuCard(
            context,
            title: 'Câu hỏi đã đánh dấu',
            subtitle: '${bookmarkedQuestions.length} câu đã lưu lại để ôn tập thêm',
            badgeText: bookmarkedQuestions.isNotEmpty ? '${bookmarkedQuestions.length}' : null,
            badgeColor: AppColors.warning,
            onTap: () => _openStudySession(
              context,
              title: 'Câu đã đánh dấu',
              questions: bookmarkedQuestions,
            ),
          ),
          const SizedBox(height: 10),

          // Thẻ Nguồn dữ liệu & Miễn trừ trách nhiệm
          _buildMenuCard(
            context,
            title: 'Nguồn dữ liệu & Miễn trừ',
            subtitle: 'Liên kết cổng Cục Đường bộ VN (.gov.vn) & tuyên bố pháp lý',
            onTap: () => GovernmentSourceDialog.show(context),
          ),
          const SizedBox(height: 22),

          // Lịch sử thi sát hạch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch sử thi sát hạch',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 17,
                ),
              ),
              if (examHistory.isNotEmpty)
                TextButton(
                  onPressed: () => userDataProvider.clearExamHistory(),
                  child: Text(
                    'Xóa lịch sử',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (examHistory.isEmpty)
            _buildEmptyHistoryCard()
          else
            ...examHistory.map(_buildExamHistoryItem),

          const SizedBox(height: 16),

          // Khối miễn trừ trách nhiệm
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tuyên bố pháp lý & Miễn trừ trách nhiệm',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ứng dụng "Trắc nghiệm Lái xe A1" do nhà phát triển độc lập xây dựng nhằm hỗ trợ người học ôn luyện lý thuyết. Ứng dụng KHÔNG đại diện, không trực thuộc và không được ủy quyền bởi Bộ Giao thông Vận tải hay bất kỳ cơ quan chính phủ nào của Việt Nam.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => GovernmentSourceDialog.show(context),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Xem chi tiết nguồn dữ liệu chính thức (.gov.vn) →',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
  }

  Widget _buildEmptyHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Chưa có bài thi nào',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hãy bắt đầu bài thi sát hạch để lưu lịch sử và đánh giá tỷ lệ đỗ.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamHistoryItem(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            item.isPassed ? StatusBadge.passed() : StatusBadge.failed(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.score}/${item.totalQuestions} câu đúng',
                    style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.formattedDuration} · ${item.formattedDate}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
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
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
