/// Model đại diện cho một chương ôn tập lý thuyết A1
class Topic {
  final int id;
  final String name;
  final String description;
  final int totalQuestions;
  final int criticalQuestionsCount;

  const Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.totalQuestions,
    required this.criticalQuestionsCount,
  });

  /// Danh mục 5 chương chuẩn của bộ đề A1
  static const List<Topic> defaultTopics = [
    Topic(
      id: 1,
      name: 'Khái niệm và quy tắc',
      description: 'Khái niệm cơ bản, quy tắc giao thông đường bộ, tốc độ và khoảng cách',
      totalQuestions: 83,
      criticalQuestionsCount: 10,
    ),
    Topic(
      id: 2,
      name: 'Văn hóa và đạo đức lái xe',
      description: 'Đạo đức nghề nghiệp, văn hóa ứng xử khi tham gia giao thông',
      totalQuestions: 5,
      criticalQuestionsCount: 0,
    ),
    Topic(
      id: 3,
      name: 'Kỹ thuật lái xe',
      description: 'Kỹ năng điều khiển xe mô tô, phanh xe, vào cua an toàn',
      totalQuestions: 12,
      criticalQuestionsCount: 2,
    ),
    Topic(
      id: 4,
      name: 'Hệ thống biển báo đường bộ',
      description: 'Biển cấm, biển hiệu lệnh, biển cảnh báo nguy hiểm, biển chỉ dẫn',
      totalQuestions: 65,
      criticalQuestionsCount: 4,
    ),
    Topic(
      id: 5,
      name: 'Giải các thế sa hình',
      description: 'Xử lý tình huống giao thông, thứ tự ưu tiên các xe tại ngã tư',
      totalQuestions: 35,
      criticalQuestionsCount: 4,
    ),
  ];
}
