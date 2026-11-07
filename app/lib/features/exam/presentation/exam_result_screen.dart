import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../domain/exam_model.dart';
import 'exam_coordinator.dart';

/// Màn hình Kết quả thi sát hạch — Clean, Modern Material 3
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
    final isPassed = result.isPassed;
    final verdictColor = isPassed ? AppColors.success : AppColors.error;

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
              icon: const Icon(Icons.close),
              tooltip: 'Về trang chủ',
              onPressed: () => coordinator.handleNavigateHome(context),
            ),
          ],
        ),
        body: SafeArea(
          child: ResponsiveContainer(
            maxWidth: 640,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
              // Thẻ kết quả tinh gọn
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: verdictColor.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      isPassed ? 'KẾT QUẢ: ĐẠT' : 'KẾT QUẢ: KHÔNG ĐẠT',
                      style: AppTypography.titleLarge.copyWith(
                        color: verdictColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${result.score}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: verdictColor,
                            height: 1,
                          ),
                        ),
                        Text(
                          ' / ${result.totalQuestions} câu',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isPassed
                          ? 'Chúc mừng! Bạn đã đủ điều kiện vượt qua phần thi lý thuyết mô tô A1.'
                          : result.isCriticalFailed
                              ? 'Bạn đã trả lời sai câu điểm liệt — Bị đánh trượt bất kể tổng số điểm đạt được.'
                              : 'Bạn chưa đạt yêu cầu tối thiểu (yêu cầu đúng từ 21/25 câu trở lên).',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bảng thông số chi tiết phẳng
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _buildStatItem(
                      label: 'KẾT QUẢ ĐIỂM',
                      value: '${result.score}/${result.totalQuestions}',
                      valueColor: verdictColor,
                    ),
                    Container(height: 36, width: 1, color: AppColors.divider),
                    _buildStatItem(
                      label: 'THỜI GIAN',
                      value: result.formattedDuration,
                      valueColor: AppColors.textPrimary,
                    ),
                    Container(height: 36, width: 1, color: AppColors.divider),
                    _buildStatItem(
                      label: 'CÂU ĐIỂM LIỆT',
                      value: result.isCriticalFailed ? 'Sai câu liệt' : 'Chính xác',
                      valueColor: result.isCriticalFailed ? AppColors.error : AppColors.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Các nút hành động chính
              AppButton(
                label: 'Xem lại bài thi chi tiết',
                type: AppButtonType.primary,
                onPressed: () => coordinator.handleReviewExam(context, result),
              ),
              const SizedBox(height: 10),

              AppButton(
                label: 'Thi lại đề ngẫu nhiên khác',
                type: AppButtonType.outlined,
                onPressed: () => coordinator.handleRetakeExam(context),
              ),
              const SizedBox(height: 10),

              AppButton(
                label: 'Quay về trang chủ',
                type: AppButtonType.secondary,
                onPressed: () => coordinator.handleNavigateHome(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
