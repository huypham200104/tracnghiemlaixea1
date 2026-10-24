import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../domain/exam_model.dart';
import 'exam_coordinator.dart';

/// Màn hình Kết quả thi sát hạch (ĐẠT / TRƯỢT) — Tuân thủ SRP và DIP
class ExamResultScreen extends StatelessWidget {
  final ExamResult result;
  final ExamCoordinator coordinator;

  const ExamResultScreen({
    super.key,
    required this.result,
    this.coordinator = const ExamCoordinator(),
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          coordinator.handleNavigateHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(
          title: const Text('Kết quả thi sát hạch'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Về trang chủ',
              onPressed: () => coordinator.handleNavigateHome(context),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
            // Banner ĐẠT / TRƯỢT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: result.isPassed ? AppColors.successContainer : AppColors.errorContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: result.isPassed ? AppColors.success : AppColors.error,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    result.isPassed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 64,
                    color: result.isPassed ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.isPassed ? 'ĐẠT' : 'TRƯỢT',
                    style: AppTypography.headlineLarge.copyWith(
                      color: result.isPassed ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.isPassed
                        ? 'Chúc mừng bạn đã vượt qua bài thi lý thuyết sát hạch lái xe A1!'
                        : result.isCriticalFailed
                            ? 'Bạn đã trả lời sai CÂU ĐIỂM LIỆT — Bị đánh trượt bất kể tổng số điểm đạt được.'
                            : 'Rất tiếc! Điểm của bạn chưa đạt yêu cầu tối thiểu (≥ 21/25 câu đúng).',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: result.isPassed ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bảng thông số chi tiết
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildStatItem(
                    label: 'Số câu đúng',
                    value: '${result.score}/${result.totalQuestions}',
                    valueColor: result.isPassed ? AppColors.success : AppColors.error,
                  ),
                  Container(height: 40, width: 1, color: AppColors.divider),
                  _buildStatItem(
                    label: 'Thời gian làm',
                    value: result.formattedDuration,
                    valueColor: AppColors.primary,
                  ),
                  Container(height: 40, width: 1, color: AppColors.divider),
                  _buildStatItem(
                    label: 'Điểm liệt',
                    value: result.isCriticalFailed ? 'Sai' : 'Đạt',
                    valueColor: result.isCriticalFailed ? AppColors.error : AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Các nút hành động chính (DIP qua Coordinator)
            AppButton(
              label: 'Xem lại bài thi vừa làm',
              icon: Icons.assignment_outlined,
              type: AppButtonType.primary,
              onPressed: () => coordinator.handleReviewExam(context, result),
            ),
            const SizedBox(height: 12),

            AppButton(
              label: 'Thi lại đề khác',
              icon: Icons.refresh,
              type: AppButtonType.outlined,
              onPressed: () => coordinator.handleRetakeExam(context),
            ),
            const SizedBox(height: 12),

            AppButton(
              label: 'Về trang chủ',
              icon: Icons.home_outlined,
              type: AppButtonType.secondary,
              onPressed: () => coordinator.handleNavigateHome(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
