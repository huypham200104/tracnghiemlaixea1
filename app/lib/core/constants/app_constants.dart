/// Hằng số nghiệp vụ sát hạch lý thuyết lái xe mô tô Hạng A1 (Bộ GTVT)
class AppConstants {
  AppConstants._();

  /// Tổng số câu hỏi trong bộ đề chuẩn A1
  static const int totalQuestions = 200;

  /// Số câu hỏi trong 1 đề thi sát hạch
  static const int examQuestionCount = 25;

  /// Thời gian làm bài thi sát hạch tính theo phút
  static const int examDurationMinutes = 19;

  /// Thời gian làm bài thi tính theo giây (19 phút * 60)
  static const int examDurationSeconds = 19 * 60;

  /// Số câu đúng tối thiểu để ĐẠT
  static const int passingScore = 21;

  /// Tổng số câu điểm liệt trong bộ đề A1
  static const int criticalQuestionCount = 20;

  /// Thời gian cảnh báo đỏ đếm ngược (5 phút = 300 giây)
  static const int examWarningSeconds = 5 * 60;
}
