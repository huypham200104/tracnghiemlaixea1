import 'package:flutter/material.dart';

/// Bảng màu ngữ nghĩa giao thông chuẩn Material 3 theo DESIGN.md
class AppColors {
  AppColors._();

  // Semantic Primary (Xanh dương)
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryContainer = Color(0xFFE3F2FD);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Semantic Success (Xanh lá - Đúng, ĐẠT)
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color onSuccess = Color(0xFFFFFFFF);

  // Semantic Error (Đỏ - Sai, TRƯỢT, Câu điểm liệt)
  static const Color error = Color(0xFFC62828);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color onError = Color(0xFFFFFFFF);

  // Semantic Warning (Cam - Chưa làm, Bookmark, Đếm ngược ≤ 5p)
  static const Color warning = Color(0xFFEF6C00);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color onWarning = Color(0xFFFFFFFF);

  // Backgrounds & Surfaces
  static const Color canvas = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD8DCE5);
  static const Color divider = Color(0xFFE5E7EB);

  // Typography Colors
  static const Color textPrimary = Color(0xFF1B1B1F);
  static const Color textSecondary = Color(0xFF525866);
  static const Color textDisabled = Color(0xFF9E9E9E);
}
