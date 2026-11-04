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

/// Màn hình Trang chủ (Tab 1) — Clean, Flat, Modern Material 3
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
              // 1. Header tinh gọn
              const HomeHeader(),
              const SizedBox(height: 18),

              // 2. Thẻ tiến độ tổng quan phẳng
              HomeProgressCard(
                totalQuestions: totalQ,
                criticalQuestionsCount: AppConstants.criticalQuestionCount,
              ),
              const SizedBox(height: 14),

              // 3. Hero CTA: Thi sát hạch phẳng
              ExamCtaCard(onTapStart: () => coordinator.handleStartExam(context)),
              const SizedBox(height: 22),

              // 4. Tiêu đề Lối tắt
              Text(
                'Danh mục chức năng',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),

              // 5. Quick Access Grid tối giản
              QuickAccessGrid(
                items: [
                  QuickAccessItem(
                    title: 'Ôn tập 5 chương',
                    subtitle: 'Toàn bộ 200 câu hỏi',
                    onTap: () => coordinator.handleNavigateTab(1),
                  ),
                  QuickAccessItem(
                    title: '20 Câu điểm liệt',
                    subtitle: 'Bắt buộc làm đúng',
                    onTap: () => coordinator.handleNavigateTab(1),
                  ),
                  QuickAccessItem(
                    title: 'Biển báo đường bộ',
                    subtitle: '5 nhóm biển chuẩn',
                    onTap: () => coordinator.handleNavigateTab(2),
                  ),
                  QuickAccessItem(
                    title: 'Sổ tay câu sai',
                    subtitle: 'Luyện lại câu nhầm',
                    badgeCount: wrongCount,
                    onTap: () => coordinator.handleNavigateTab(3),
                  ),
                  QuickAccessItem(
                    title: 'Mẹo thi A1',
                    subtitle: '5 quy tắc sa hình 3D',
                    onTap: () => coordinator.handleShowTips(context),
                  ),
                  QuickAccessItem(
                    title: 'Lịch sử thi',
                    subtitle: 'Xem lại bài đã làm',
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
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
                _buildLatestExamCard(latestExam, () => coordinator.handleNavigateTab(3)),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestExamCard(dynamic latestExam, VoidCallback onTap) {
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
              latestExam.isPassed ? StatusBadge.passed() : StatusBadge.failed(),
              const SizedBox(width: 14),
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
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
