import '../domain/../../study/domain/question_model.dart';

/// Kết quả câu trả lời của thí sinh cho một câu hỏi
class ExamAnswer {
  final Question question;
  final int? selectedIndex;

  const ExamAnswer({
    required this.question,
    this.selectedIndex,
  });

  bool get isAnswered => selectedIndex != null;

  bool get isCorrect => selectedIndex != null && selectedIndex == question.correctIndex;

  bool get isCriticalWrong => question.isCritical && selectedIndex != null && selectedIndex != question.correctIndex;
}

/// Kết quả tổng hợp bài thi sát hạch
class ExamResult {
  final String id;
  final int timestamp;
  final int score;
  final int totalQuestions;
  final bool isPassed;
  final bool isCriticalFailed;
  final int durationSeconds;
  final Map<int, int?> answers; // questionId -> selectedIndex

  const ExamResult({
    required this.id,
    required this.timestamp,
    required this.score,
    required this.totalQuestions,
    required this.isPassed,
    required this.isCriticalFailed,
    required this.durationSeconds,
    required this.answers,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'] as Map<String, dynamic>? ?? {};
    final parsedAnswers = rawAnswers.map(
      (key, value) => MapEntry(int.parse(key), value as int?),
    );

    return ExamResult(
      id: json['id'] as String,
      timestamp: json['timestamp'] as int,
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int? ?? 25,
      isPassed: json['isPassed'] as bool,
      isCriticalFailed: json['isCriticalFailed'] as bool? ?? false,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      answers: parsedAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'score': score,
      'totalQuestions': totalQuestions,
      'isPassed': isPassed,
      'isCriticalFailed': isCriticalFailed,
      'durationSeconds': durationSeconds,
      'answers': answers.map((key, value) => MapEntry(key.toString(), value)),
    };
  }

  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
