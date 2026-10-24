import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../study/state/study_provider.dart';
import '../../profile/state/user_data_provider.dart';
import 'home_coordinator.dart';
import 'widgets/exam_cta_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_progress_card.dart';
import 'widgets/quick_access_grid.dart';

/// Màn hình Trang chủ (Tab 1) — Tuân thủ SRP, DIP và OCP
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final coordinator = HomeCoordinator(onNavigateTab: onNavigateTab);
    final studyProvider = context.watch<StudyProvider>();
    final userDataProvider = context.watch<UserDataProvider>();
    final latestExam = userDataProvider.latestExamResult;

    final wrongCount = userDataProvider.wrongQuestionIds.length;
    final totalQ = studyProvider.totalQuestions > 0
        ? studyProvider.totalQuestions
        : AppConstants.totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (SRP)
              const HomeHeader(),
              const SizedBox(height: 18),

              // 2. Thẻ tiến độ tổng quan (SRP)
              HomeProgressCard(
                totalQuestions: totalQ,
                criticalQuestionsCount: AppConstants.criticalQuestionCount,
              ),
              const SizedBox(height: 16),

              // 3. Hero CTA: Thi sát hạch (DIP)
              ExamCtaCard(onTapStart: () => coordinator.handleStartExam(context)),
              const SizedBox(height: 20),

              // 4. Tiêu đề Lối tắt
              Text(
                'Danh mục chức năng',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // 5. Quick Access Grid (OCP)
              QuickAccessGrid(
                items: [
                  QuickAccessItem(
                    title: 'Ôn tập 5 chương',
                    subtitle: 'Toàn bộ 200 câu hỏi',
                    icon: Icons.menu_book,
                    iconColor: AppColors.primary,
                    bgColor: AppColors.primaryContainer,
                    onTap: () => coordinator.handleNavigateTab(1),
                  ),
                  QuickAccessItem(
                    title: '20 Câu điểm liệt',
                    subtitle: 'Sai 1 câu là trượt',
                    icon: Icons.warning_rounded,
                    iconColor: AppColors.error,
                    bgColor: AppColors.errorContainer,
                    onTap: () => coordinator.handleNavigateTab(1),
                  ),
                  QuickAccessItem(
                    title: 'Biển báo đường bộ',
                    subtitle: '5 nhóm biển chuẩn',
                    icon: Icons.traffic,
                    iconColor: AppColors.primary,
                    bgColor: AppColors.primaryContainer,
                    onTap: () => coordinator.handleNavigateTab(2),
                  ),
                  QuickAccessItem(
                    title: 'Sổ tay câu sai',
                    subtitle: 'Luyện lại câu hay nhầm',
                    icon: Icons.cancel_outlined,
                    iconColor: AppColors.error,
                    bgColor: AppColors.errorContainer,
                    badgeCount: wrongCount,
                    onTap: () => coordinator.handleNavigateTab(3),
                  ),
                  QuickAccessItem(
                    title: 'Mẹo thi A1',
                    subtitle: 'Lý thuyết & sa hình',
                    icon: Icons.lightbulb_outline,
                    iconColor: AppColors.warning,
                    bgColor: AppColors.warningContainer,
                    onTap: () => coordinator.handleShowTips(context),
                  ),
                  QuickAccessItem(
                    title: 'Lịch sử thi',
                    subtitle: 'Xem lại bài làm',
                    icon: Icons.history,
                    iconColor: AppColors.primary,
                    bgColor: AppColors.primaryContainer,
                    onTap: () => coordinator.handleNavigateTab(3),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 6. Khối lần thi gần nhất
              if (latestExam != null) ...[
                Text(
                  'Lần thi gần nhất',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildLatestExamCard(latestExam),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestExamCard(dynamic latestExam) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          latestExam.isPassed ? StatusBadge.passed() : StatusBadge.failed(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kết quả: ${latestExam.score}/${latestExam.totalQuestions} câu đúng',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Thời gian: ${latestExam.formattedDuration} · ${latestExam.formattedDate}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
