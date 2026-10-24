import 'package:flutter/material.dart';
import '../../features/traffic_signs/domain/traffic_sign_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Widget hiển thị đồ họa nhận diện biển báo giao thông chuẩn quy chuẩn QCVN 41:2019
class TrafficSignAvatar extends StatelessWidget {
  final TrafficSign sign;
  final double size;

  const TrafficSignAvatar({
    super.key,
    required this.sign,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    if (sign.image != null && sign.image!.isNotEmpty) {
      return Image.asset(
        sign.image!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildShapeAvatar(),
      );
    }
    return _buildShapeAvatar();
  }

  Widget _buildShapeAvatar() {
    switch (sign.group) {
      case 'cam':
        // Biển cấm: Hình tròn viền đỏ, nền trắng
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: AppColors.error,
              width: size * 0.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            sign.code.replaceAll('P.', ''),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w900,
              fontSize: size * 0.26,
            ),
            textAlign: TextAlign.center,
          ),
        );

      case 'hieulenh':
        // Biển hiệu lệnh: Hình tròn nền xanh dương lam
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(
              color: Colors.white,
              width: size * 0.04,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            sign.code.replaceAll('R.', ''),
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: size * 0.24,
            ),
            textAlign: TextAlign.center,
          ),
        );

      case 'nguyhiem':
        // Biển cảnh báo nguy hiểm: Hình tam giác vàng viền đỏ
        return CustomPaint(
          size: Size(size, size),
          painter: _TriangleSignPainter(),
          child: SizedBox(
            width: size,
            height: size,
            child: Align(
              alignment: const Alignment(0, 0.25),
              child: Text(
                sign.code.replaceAll('W.', ''),
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.22,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );

      case 'chidan':
        // Biển chỉ dẫn: Hình vuông / chữ nhật nền xanh lam
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(size * 0.15),
            border: Border.all(
              color: Colors.white,
              width: size * 0.04,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            sign.code.replaceAll('I.', ''),
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: size * 0.24,
            ),
            textAlign: TextAlign.center,
          ),
        );

      case 'phu':
      default:
        // Biển phụ: Hình chữ nhật trắng viền đen
        return Container(
          width: size,
          height: size * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.08),
            border: Border.all(
              color: Colors.black87,
              width: size * 0.05,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            sign.code,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: size * 0.22,
            ),
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}

/// Painter vẽ tam giác cảnh báo nguy hiểm nền vàng viền đỏ
class _TriangleSignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final strokeWidth = size.width * 0.09;

    // Đỉnh trên, góc dưới phải, góc dưới trái
    path.moveTo(size.width / 2, strokeWidth / 2);
    path.lineTo(size.width - strokeWidth / 2, size.height - strokeWidth / 2);
    path.lineTo(strokeWidth / 2, size.height - strokeWidth / 2);
    path.close();

    // Nền vàng
    final fillPaint = Paint()
      ..color = const Color(0xFFFFD54F) // Vàng giao thông
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Viền đỏ
    final strokePaint = Paint()
      ..color = AppColors.error
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
