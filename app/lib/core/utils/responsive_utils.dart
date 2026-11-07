import 'package:flutter/material.dart';

/// Điểm ngắt chuẩn cho Responsive Design theo DESIGN.md
class AppBreakpoints {
  AppBreakpoints._();

  /// Ngưỡng máy tính bảng / màn hình ngang (Tablet Breakpoint)
  static const double tablet = 600.0;

  /// Ngưỡng màn hình máy tính để bàn (Desktop Breakpoint)
  static const double desktop = 1024.0;
}

/// Tiện ích Responsive mở rộng trên BuildContext
extension ResponsiveContext on BuildContext {
  /// Kiểm tra có đang hiển thị trên Tablet / Màn hình rộng (≥ 600dp) không
  bool get isTablet => MediaQuery.sizeOf(this).width >= AppBreakpoints.tablet;

  /// Kiểm tra có đang hiển thị trên Desktop (≥ 1024dp) không
  bool get isDesktop => MediaQuery.sizeOf(this).width >= AppBreakpoints.desktop;

  /// Chiều rộng hiện tại của màn hình
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Chiều cao hiện tại của màn hình
  double get screenHeight => MediaQuery.sizeOf(this).height;
}

/// Widget bọc giới hạn độ rộng tối đa và căn giữa nội dung trên Tablet/Desktop
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 720.0,
    this.alignment = Alignment.topCenter,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}
