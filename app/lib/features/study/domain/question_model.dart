/// Model đại diện cho một câu hỏi lý thuyết trắc nghiệm A1
class Question {
  final int id;
  final int topicId;
  final String content;
  final List<String> options;
  final int correctIndex;
  final bool isCritical;
  final String? image;
  final String explanation;

  const Question({
    required this.id,
    required this.topicId,
    required this.content,
    required this.options,
    required this.correctIndex,
    required this.isCritical,
    this.image,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      topicId: json['topicId'] as int,
      content: json['content'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      isCritical: json['isCritical'] as bool? ?? false,
      image: json['image'] as String?,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'content': content,
      'options': options,
      'correctIndex': correctIndex,
      'isCritical': isCritical,
      'image': image,
      'explanation': explanation,
    };
  }

  Question copyWith({
    int? id,
    int? topicId,
    String? content,
    List<String>? options,
    int? correctIndex,
    bool? isCritical,
    String? image,
    String? explanation,
  }) {
    return Question(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      content: content ?? this.content,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      isCritical: isCritical ?? this.isCritical,
      image: image ?? this.image,
      explanation: explanation ?? this.explanation,
    );
  }
}
