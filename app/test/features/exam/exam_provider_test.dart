import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/exam/state/exam_provider.dart';
import 'package:app/features/study/domain/question_model.dart';

void main() {
  group('ExamProvider Business Logic Tests', () {
    late ExamProvider provider;

    List<Question> createMockQuestions() {
      return List.generate(25, (index) {
        return Question(
          id: index + 1,
          topicId: 1,
          content: 'Question ${index + 1}',
          options: ['A', 'B', 'C', 'D'],
          correctIndex: 0,
          isCritical: index == 0, // Câu 1 là câu điểm liệt
          explanation: 'Exp',
        );
      });
    }

    setUp(() {
      provider = ExamProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    test('startExam initializes exam state cleanly', () {
      final mockQuestions = createMockQuestions();
      provider.startExam(mockQuestions, shuffle: false);

      expect(provider.totalQuestions, 25);
      expect(provider.currentIndex, 0);
      expect(provider.answeredCount, 0);
      expect(provider.unansweredCount, 25);
      expect(provider.isSubmitted, isFalse);
    });

    test('selectAnswer updates answers and answer count', () {
      final mockQuestions = createMockQuestions();
      provider.startExam(mockQuestions, shuffle: false);

      provider.selectAnswer(1); // Chọn đáp án B cho câu 1
      expect(provider.answeredCount, 1);
      expect(provider.unansweredCount, 24);
      expect(provider.isQuestionAnswered(0), isTrue);
      expect(provider.isQuestionAnswered(1), isFalse);
    });

    test('Passing exam: >= 21 correct and no critical wrong', () {
      final mockQuestions = createMockQuestions();
      provider.startExam(mockQuestions, shuffle: false);

      // Trả lời đúng 21 câu đầu (bao gồm câu 1 là câu điểm liệt đúng: option 0)
      for (int i = 0; i < 21; i++) {
        provider.goToQuestion(i);
        provider.selectAnswer(0); // Đáp án đúng là 0
      }

      final result = provider.submitExam();
      expect(result.score, 21);
      expect(result.isCriticalFailed, isFalse);
      expect(result.isPassed, isTrue);
    });

    test('Failing exam: 24/25 correct BUT critical question wrong leads to immediate FAIL', () {
      final mockQuestions = createMockQuestions();
      provider.startExam(mockQuestions, shuffle: false);

      // Câu 1 (điểm liệt): chọn sai (option 1 thay vì 0)
      provider.goToQuestion(0);
      provider.selectAnswer(1);

      // 24 câu còn lại: chọn đúng (option 0)
      for (int i = 1; i < 25; i++) {
        provider.goToQuestion(i);
        provider.selectAnswer(0);
      }

      final result = provider.submitExam();
      expect(result.score, 24);
      expect(result.isCriticalFailed, isTrue);
      expect(result.isPassed, isFalse, reason: 'Phải trượt do sai câu điểm liệt');
    });

    test('Failing exam: 24/25 correct BUT critical question left UNANSWERED leads to immediate FAIL', () {
      final mockQuestions = createMockQuestions();
      provider.startExam(mockQuestions, shuffle: false);

      // Câu 1 (điểm liệt): bỏ trống (không chọn đáp án)

      // 24 câu còn lại: chọn đúng (option 0)
      for (int i = 1; i < 25; i++) {
        provider.goToQuestion(i);
        provider.selectAnswer(0);
      }

      final result = provider.submitExam();
      expect(result.score, 24);
      expect(result.isCriticalFailed, isTrue);
      expect(result.isPassed, isFalse, reason: 'Phải trượt do chưa trả lời câu điểm liệt');
    });

    test('Failing exam: score < 21', () {
      final mockQuestions = createMockQuestions();
      provider.startExam(mockQuestions, shuffle: false);

      // Chỉ trả lời đúng 20 câu
      for (int i = 0; i < 20; i++) {
        provider.goToQuestion(i);
        provider.selectAnswer(0);
      }

      final result = provider.submitExam();
      expect(result.score, 20);
      expect(result.isPassed, isFalse);
    });
  });
}
