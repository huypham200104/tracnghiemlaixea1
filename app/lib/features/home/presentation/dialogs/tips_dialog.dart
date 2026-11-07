import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/image_zoom_dialog.dart';

/// Dialog hiển thị toàn bộ mẹo ghi nhớ nhanh & 5 quy tắc Sa hình 3D chuẩn Bộ GTVT
class TipsDialog extends StatefulWidget {
  const TipsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showAppDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const TipsDialog(),
    );
  }

  @override
  State<TipsDialog> createState() => _TipsDialogState();
}

class _TipsDialogState extends State<TipsDialog> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabs = [
    '5 Quy tắc Sa hình 3D',
    '20 Câu điểm liệt',
    'Thực hành Vòng số 8',
    'Mẹo mẹo mẹo chữ',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.width > 600;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? (mediaQuery.size.width - 560) / 2 : 12,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border, width: 0.8),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      backgroundColor: AppColors.canvas,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.88,
          maxWidth: 580,
        ),
        child: Column(
          children: [
            // Header Dialog
            Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
              color: AppColors.surface,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warningContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.warning,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cẩm nang Mẹo thi A1',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '5 quy tắc Sa hình 3D & kinh nghiệm thi đỗ',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.canvas,
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(36, 36),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Đóng',
                  ),
                ],
              ),
            ),

            // Tab Bar Lựa chọn danh mục
            Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w500),
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: AppColors.divider),

            // Tab View Nội dung
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSaHinhTab(context),
                  _buildDiemLietTab(context),
                  _buildThucHanhTab(context),
                  _buildMeoChuTab(context),
                ],
              ),
            ),

            // Bottom action
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đã hiểu, quay lại học tiếp',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tab 1: 5 Quy tắc Sa hình với ảnh 3D chuẩn Bộ GTVT
  Widget _buildSaHinhTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Khẩu quyết tóm tắt
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khẩu quyết giải sa hình bất bại:',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '1. Nhất chớm  →  2. Nhì ưu  →  3. Tam đường  →  4. Tứ hướng',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Quy tắc 1
        _buildRuleCard(
          context: context,
          badge: 'QUY TẮC 1',
          badgeColor: AppColors.primary,
          title: 'Nhất chớm: Xe đã vào giao lộ đi trước',
          subtitle: 'Xe đã chớm qua vạch người đi bộ hoặc vào tâm ngã tư',
          description:
              'Xe nào đã đi vào trong giao lộ (chớm vào ngã tư) thì luôn luôn được quyền đi trước tất cả các phương tiện khác, kể cả các xe ưu tiên (như Cứu hỏa, Quân sự, Công an, Cứu thương).',
          images: [
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_194.png',
              caption: 'Xe con A đã vào giao lộ trước thì được quyền đi trước dù có xe cứu hỏa',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quy tắc 2
        _buildRuleCard(
          context: context,
          badge: 'QUY TẮC 2',
          badgeColor: AppColors.error,
          title: 'Nhì ưu: Thứ tự xe ưu tiên theo Luật',
          subtitle: 'Khẩu quyết: Hỏa → Sự → An → Thương',
          description:
              '1. Hỏa: Xe cứu hỏa đi làm nhiệm vụ (ưu tiên cao nhất)\n'
              '2. Sự: Xe quân sự đi làm nhiệm vụ khẩn cấp\n'
              '3. An: Xe công an đi làm nhiệm vụ khẩn cấp\n'
              '4. Thương: Xe cứu thương đang phát tín hiệu cấp cứu\n'
              '5. Xe hộ đê, xe tang.\n'
              '→ Nếu cùng gặp nhau ở ngã tư: Cứu hỏa luôn được đi trước Xe công an và Cứu thương.',
          images: [
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_xe_uu_tien.png',
              caption: 'Xe cứu hỏa được quyền đi trước xe cứu thương và xe con',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quy tắc 3
        _buildRuleCard(
          context: context,
          badge: 'QUY TẮC 3',
          badgeColor: AppColors.warning,
          title: 'Tam đường: Đường ưu tiên đi trước',
          subtitle: 'Nhận biết biển báo hiệu đường ưu tiên tại giao lộ',
          description:
              'Xe nào đi trên đoạn đường có biển báo ưu tiên sẽ được quyền qua giao lộ trước:\n'
              '• Biển I.401 (Hình thoi vàng viền trắng): Bắt đầu đường ưu tiên → ĐƯỢC ĐI TRƯỚC.\n'
              '• Biển W.207 (Tam giác vàng viền đỏ, mũi tên đen lớn): Giao nhau với đường không ưu tiên → ĐƯỢC ĐI TRƯỚC.\n'
              '• Biển W.208 (Tam giác ngược viền đỏ): Giao nhau với đường ưu tiên → BẮT BUỘC NHƯỜNG ĐƯỜNG.',
          images: [
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_168.png',
              caption: 'Xe trên đường có biển ưu tiên (W.207 / I.401) được qua ngã tư trước',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quy tắc 4
        _buildRuleCard(
          context: context,
          badge: 'QUY TẮC 4',
          badgeColor: AppColors.success,
          title: 'Tứ hướng: Quyền bên phải & Hướng rẽ',
          subtitle: 'Bên phải không vướng → Rẽ phải → Đi thẳng → Rẽ trái',
          description:
              'Tại ngã tư đường cùng cấp (không có biển báo ưu tiên):\n'
              '1. Xe nào có phía bên phải trống (không bị xe khác vướng) được đi đầu tiên.\n'
              '2. Thứ tự ưu tiên theo hướng di chuyển: Xe Rẽ Phải đi trước → Xe Đi Thẳng đi tiếp theo → Xe Rẽ Trái đi sau cùng (vì rẽ trái phải cắt ngang làn đường khác).',
          images: [
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_thu_tu_huong_di.png',
              caption: 'Xe rẽ phải đi trước → Xe đi thẳng → Xe rẽ trái đi sau cùng',
            ),
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_nga_tu_cung_cap.png',
              caption: 'Giao lộ cùng cấp: xe có bên phải không vướng được quyền đi trước',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quy tắc 5
        _buildRuleCard(
          context: context,
          badge: 'QUY TẮC 5',
          badgeColor: const Color(0xFF5C6BC0),
          title: 'Hiệu lệnh CSGT & Tín hiệu đèn',
          subtitle: 'Hiệu lệnh của người điều khiển giao thông có hiệu lực cao nhất',
          description:
              '• CSGT giơ 1 tay thẳng đứng: Tất cả các xe ở mọi hướng đều phải dừng lại (trừ các xe đã lọt vào ngã tư).\n'
              '• CSGT dang ngang 2 tay (hoặc 1 tay): Xe ở phía trước & sau dừng lại; Xe ở bên phải & bên trái được đi tất cả các hướng.\n'
              '• Đèn tín hiệu: Đèn đỏ dừng lại; Đèn vàng giảm tốc độ dừng trước vạch dừng; Đèn xanh được phép đi. Quan sát kỹ đèn phụ hình mũi tên!',
          images: [
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_csgt_tay_dung.png',
              caption: 'Hiệu lệnh CSGT: Người điều khiển GT giơ tay ra hiệu',
            ),
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_den_do.png',
              caption: 'Chấp hành tín hiệu đèn giao thông tại ngã tư phân làn',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quy tắc bổ trợ
        _buildRuleCard(
          context: context,
          badge: 'MẸO BỔ TRỢ',
          badgeColor: const Color(0xFF00897B),
          title: 'Vòng xuyến & Nơi giao cắt đường sắt',
          subtitle: 'Quy tắc nhường đường tại các nút giao đặc biệt',
          description:
              '• Vòng xuyến (bùng binh): Có biển báo P.303 (vòng xuyến) → Bắt buộc nhường đường cho xe từ bên TRÁI tới. Không có biển báo → Nhường đường cho xe bên PHẢI.\n'
              '• Đường sắt cắt ngang: Tàu hỏa luôn được quyền ưu tiên tuyệt đối. Phương tiện đường bộ phải dừng lại cách mép ray ngoài cùng tối thiểu 5 mét khi có đèn đỏ, chuông reo hoặc barie đang đóng.',
          images: [
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_vong_xuyen.png',
              caption: 'Có biển vòng xuyến (P.303): Phải nhường đường cho xe đi từ bên trái tới',
            ),
            _ImageInfo(
              path: 'assets/images/diagrams/sa_hinh_duong_sat.png',
              caption: 'Giao cắt đường sắt: Dừng cách mép ray gần nhất tối thiểu 5m',
            ),
          ],
        ),
      ],
    );
  }

  /// Tab 2: Mẹo nhớ 20 câu điểm liệt
  Widget _buildDiemLietTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Cảnh báo điểm liệt
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CẢNH BÁO: SAI 1 CÂU = TRƯỢT NGAY!',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Trong bài thi sát hạch 25 câu, nếu bạn làm đúng 24 câu nhưng làm sai chỉ 1 câu điểm liệt thì bài thi sẽ bị kết luận KHÔNG ĐẠT (Trượt).',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildDetailCard(
          title: '1. Nhóm từ khóa CẤM TUYỆT ĐỐI (Chọn ngay đáp án)',
          subtitle: 'Gặp các hành vi này trong đáp án → Luôn chọn đáp án CẤM',
          items: [
            'Bị nghiêm cấm / Không được phép.',
            'Điều khiển xe sau khi sử dụng rượu bia, chất ma túy (Cấm tuyệt đối nồng độ cồn trong máu và hơi thở).',
            'Đua xe, cổ vũ đua xe, lạng lách, đánh võng.',
            'Buông cả hai tay; dùng chân lái xe; ngồi về một bên điều khiển xe.',
            'Sử dụng điện thoại di động, thiết bị âm thanh (trừ thiết bị trợ thính) khi đang lái xe mô tô.',
            'Chở hàng hóa cồng kềnh, kéo đẩy xe khác trên đường.',
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailCard(
          title: '2. Tình huống nguy hiểm tại nơi đường giao cắt',
          subtitle: 'Quy tắc an toàn tính mạng',
          items: [
            'Nơi đường sắt giao nhau: Khi chuông reo, đèn đỏ nhấp nháy hoặc rào chắn đang đóng → Tuyệt đối không được vượt qua.',
            'Vượt xe trên cầu hẹp 1 làn xe, nơi đường cong cua khuất tầm nhìn, đường ngầm, tràn ngập nước → CẤM VƯỢT.',
            'Gặp xe ưu tiên (Cứu hỏa, Quân sự, Công an, Cứu thương) đang phát còi, đèn ưu tiên → Phải giảm tốc độ, đi sát lề bên phải để nhường đường, cấm cản trở.',
            'Đi lùi, quay đầu xe trên đường cao tốc, trong hầm đường bộ → BỊ NGHIÊM CẤM.',
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailCard(
          title: '3. Quy định về Giấy phép lái xe & Độ tuổi A1',
          subtitle: 'Các mốc số liệu cần nhớ chính xác',
          items: [
            'Độ tuổi thi lái xe A1: Đủ 18 tuổi tròn trở lên.',
            'Hạng A1 được điều khiển: Xe mô tô 2 bánh có dung tích xi-lanh từ 50 cm³ đến dưới 175 cm³ (và xe mô tô 3 bánh dùng cho người khuyết tật).',
            'Thời hạn của GPLX hạng A1: Không có thời hạn (vô thời hạn).',
            'Hành vi mang GPLX bị tước/tẩy xóa để lái xe → Bị tước quyền cấp phép 05 năm.',
          ],
        ),
      ],
    );
  }

  /// Tab 3: Mẹo thực hành Vòng số 8
  Widget _buildThucHanhTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.successContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.two_wheeler_rounded, color: AppColors.success, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4 BÀI THI SA HÌNH THỰC HÀNH A1',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thứ tự: 1. Vòng số 8 → 2. Đường thẳng hẹp → 3. Đường quanh co có cản → 4. Đường gồ ghề. Đạt 80/100 điểm là ĐẬU.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildDetailCard(
          title: '1. Bí quyết chạy Vòng số 8 không chạm vạch',
          subtitle: 'Bài thi chiếm 80% tỷ lệ đỗ trượt thực hành',
          items: [
            'Vào số 2 hoặc số 3: Tuyệt đối không đi số 1 vì xe bị giật mạnh khi nhích ga rất dễ chống chân; Không đi số 4 vì xe yếu dễ chết máy.',
            'Giữ đều tay ga: Nhẹ nhàng giữ ga liên tục ở một mức, kết hợp rà nhẹ phanh chân nếu cảm thấy xe chạy quá nhanh.',
            'TUYỆT ĐỐI KHÔNG BÓP PHANH TRƯỚC: Khi đang nghiêng xe ôm cua, bóp phanh tay (phanh trước) sẽ làm khóa bánh trước và ngã xe ngay lập tức.',
            'Mở rộng vòng cua: Khi bắt đầu vào vòng số 8, ép sát bánh xe vào mép vạch ngoài để chừa bán kính cho bánh sau không đè vạch trong.',
            'Mắt nhìn xa: Luôn hướng mắt nhìn về điểm thoát của khúc cua kế tiếp, không cắm mắt nhìn xuống bánh trước.',
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailCard(
          title: '2. Các bài thi tiếp theo: Đường hẹp, quanh co & gồ ghề',
          subtitle: 'Giữ thăng bằng và nhịp ga chuẩn',
          items: [
            'Bài đường thẳng hẹp: Giữ thẳng lưng, mắt nhìn thẳng về phía trước, giữ ga đều ổn định và không lắc tay lái.',
            'Bài đường quanh co: Đi tốc độ chậm vừa phải, đánh lái nhịp nhàng theo các chướng ngại vật.',
            'Bài đường gồ ghề: Thả lỏng hai tay, hơi nhấc mông khỏi yên xe một chút để giảm chấn, giữ đều ga qua các gờ giảm tốc.',
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailCard(
          title: '3. Các lỗi bị trừ điểm cần tránh',
          subtitle: 'Tránh để bị trừ dồn đến mức dưới 80 điểm',
          items: [
            'Chạm vạch 1 lần: Trừ 5 điểm.',
            'Chống chân 1 lần: Trừ 5 điểm.',
            'Chết máy: Trừ 5 điểm.',
            'Đi sai hình (chạy ngược vòng số 8): LOẠI TRỰC TIẾP (Trượt ngay).',
            'Đổ xe / Ngã xe trong sa hình: LOẠI TRỰC TIẾP (Trượt ngay).',
            'Cả 2 bánh xe đi ra ngoài hình thi: LOẠI TRỰC TIẾP.',
          ],
        ),
      ],
    );
  }

  /// Tab 4: Mẹo làm câu hỏi lý thuyết chữ nhanh
  Widget _buildMeoChuTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _buildDetailCard(
          title: '1. Thấy các cụm từ này → 99% là ĐÁP ÁN ĐÚNG',
          subtitle: 'Mẹo nhận diện đáp án nhanh',
          items: [
            '"Bị nghiêm cấm" hoặc "Bị cấm".',
            '"Không được phép", "Không được mang vác", "Không được quay đầu".',
            '"Chấp hành hiệu lệnh của người điều khiển giao thông".',
            '"Giảm tốc độ và đi về phía bên phải".',
            '"Phải nhường đường".',
            '"Cơ quan có thẩm quyền cấp phép" hoặc "Ủy ban nhân dân cấp tỉnh".',
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailCard(
          title: '2. Quy tắc tốc độ tối đa trong khu vực đông dân cư',
          subtitle: 'Áp dụng cho xe mô tô 2 bánh (A1)',
          items: [
            'Đường đôi (có dải phân cách giữa) hoặc đường một chiều có từ 2 làn xe trở lên: Tối đa 60 km/h.',
            'Đường hai chiều (không có dải phân cách giữa) hoặc đường một chiều có 1 làn xe: Tối đa 50 km/h.',
            'Xe máy chuyên dùng, xe gắn máy (kể cả xe máy điện): Tối đa 40 km/h trên mọi loại đường.',
          ],
        ),
        const SizedBox(height: 12),

        _buildDetailCard(
          title: '3. Quy tắc nồng độ cồn & Sử dụng mũ bảo hiểm',
          subtitle: 'Luật Giao thông đường bộ mới nhất',
          items: [
            'Nồng độ cồn: Nghiêm cấm tuyệt đối điều khiển xe khi trong máu hoặc hơi thở có nồng độ cồn (Zero tolerance - có cồn là bị phạt nặng và tước bằng).',
            'Mũ bảo hiểm: Bắt buộc người điều khiển và người ngồi sau phải đội mũ bảo hiểm có cài quai đúng quy cách khi tham gia giao thông trên mọi tuyến đường.',
            'Được chở tối đa 2 người trong 3 trường hợp: Chở người bệnh đi cấp cứu; Áp giải người có hành vi vi phạm pháp luật; Trẻ em dưới 14 tuổi.',
          ],
        ),
      ],
    );
  }

  /// Widget hiển thị 1 thẻ quy tắc sa hình kèm danh sách ảnh 3D
  Widget _buildRuleCard({
    required BuildContext context,
    required String badge,
    required Color badgeColor,
    required String title,
    required String subtitle,
    required String description,
    required List<_ImageInfo> images,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề & Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Hình ảnh 3D minh họa
          if (images.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: images.map((img) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              ImageZoomDialog.show(
                                context,
                                imagePath: img.path,
                                title: title,
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    minHeight: 140,
                                    maxHeight: 200,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.canvas,
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset(
                                    img.path,
                                    fit: BoxFit.contain,
                                    errorBuilder: (ctx, err, stack) {
                                      return Container(
                                        height: 140,
                                        color: AppColors.border,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Không thể tải ảnh: ${img.path}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.zoom_in, color: Colors.white, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          'Chạm để phóng to',
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (img.caption != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '• ${img.caption}',
                            style: AppTypography.bodySmall.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Lời giải thích chi tiết
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(14, 2, 14, 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Thẻ chi tiết nội dung danh sách (dành cho Điểm liệt, Thực hành, Mẹo chữ)
  Widget _buildDetailCard({
    required String title,
    required String subtitle,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ImageInfo {
  final String path;
  final String? caption;

  _ImageInfo({
    required this.path,
    this.caption,
  });
}
