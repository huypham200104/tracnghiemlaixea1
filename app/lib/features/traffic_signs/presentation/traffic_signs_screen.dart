import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/traffic_sign_avatar.dart';
import '../state/traffic_signs_provider.dart';
import 'dialogs/traffic_sign_detail_dialog.dart';

/// Màn hình Tra cứu biển báo đường bộ (Tab 3) — Tuân thủ SRP và OCP
class TrafficSignsScreen extends StatelessWidget {
  const TrafficSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signsProvider = context.watch<TrafficSignsProvider>();
    final signs = signsProvider.filteredSigns;

    final groups = [
      {'key': 'all', 'label': 'Tất cả'},
      {'key': 'exam', 'label': '⭐ Đề thi A1'},
      {'key': 'cam', 'label': 'Biển cấm'},
      {'key': 'hieulenh', 'label': 'Hiệu lệnh'},
      {'key': 'nguyhiem', 'label': 'Nguy hiểm'},
      {'key': 'chidan', 'label': 'Chỉ dẫn'},
      {'key': 'phu', 'label': 'Biển phụ'},
    ];

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Biển báo đường bộ'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: signsProvider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc mã (P.101, W.201...)',
                hintStyle: AppTypography.bodySmall,
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: signsProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: signsProvider.clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Horizontal Filter Chips (OCP)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: groups.map((g) {
                final isSelected = signsProvider.selectedGroup == g['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(g['label']!),
                    selected: isSelected,
                    onSelected: (_) => signsProvider.selectGroup(g['key']!),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primaryContainer,
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),

          // 2-Column Grid
          Expanded(
            child: signs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: AppColors.textDisabled),
                        const SizedBox(height: 8),
                        Text(
                          'Không tìm thấy biển báo phù hợp',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: signs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final sign = signs[index];
                      return InkWell(
                        onTap: () => TrafficSignDetailDialog.show(context, sign),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      sign.code,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (sign.isInExam)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.warningContainer,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.warning.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: Text(
                                        '⭐ Thi A1',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.warning,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10,
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Center(
                                  child: TrafficSignAvatar(sign: sign, size: 64),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                sign.name,
                                style: AppTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sign.groupName,
                                style: AppTypography.bodySmall.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
