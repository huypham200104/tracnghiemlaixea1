import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/storage/local_storage_service.dart';
import 'package:app/features/profile/state/user_data_provider.dart';
import 'package:app/features/exam/domain/exam_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserDataProvider Unit Tests', () {
    late LocalStorageService storageService;
    late UserDataProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await LocalStorageService.create();
      provider = UserDataProvider(storageService);
    });

    test('bookmarks management: toggle and check state', () async {
      expect(provider.isBookmarked(10), isFalse);
      expect(provider.bookmarkedIds, isEmpty);

      await provider.toggleBookmark(10);
      expect(provider.isBookmarked(10), isTrue);
      expect(provider.bookmarkedIds, contains(10));

      await provider.toggleBookmark(10);
      expect(provider.isBookmarked(10), isFalse);
      expect(provider.bookmarkedIds, isEmpty);
    });

    test('wrong questions management: add, remove, and clear', () async {
      expect(provider.isWrong(5), isFalse);
      expect(provider.wrongQuestionIds, isEmpty);

      await provider.addWrongQuestion(5);
      await provider.addWrongQuestion(8);
      expect(provider.isWrong(5), isTrue);
      expect(provider.isWrong(8), isTrue);
      expect(provider.wrongQuestionIds.length, 2);

      await provider.removeWrongQuestion(5);
      expect(provider.isWrong(5), isFalse);
      expect(provider.isWrong(8), isTrue);
      expect(provider.wrongQuestionIds, [8]);

      await provider.clearWrongQuestions();
      expect(provider.wrongQuestionIds, isEmpty);
    });

    test('exam history management: save and latest result', () async {
      expect(provider.examHistory, isEmpty);
      expect(provider.latestExamResult, isNull);

      final result1 = ExamResult(
        id: 'exam_1',
        timestamp: 1000,
        score: 22,
        totalQuestions: 25,
        isPassed: true,
        isCriticalFailed: false,
        durationSeconds: 500,
        answers: {},
      );

      final result2 = ExamResult(
        id: 'exam_2',
        timestamp: 2000,
        score: 18,
        totalQuestions: 25,
        isPassed: false,
        isCriticalFailed: false,
        durationSeconds: 600,
        answers: {},
      );

      await provider.saveExamResult(result1);
      expect(provider.examHistory.length, 1);
      expect(provider.latestExamResult?.id, 'exam_1');

      await provider.saveExamResult(result2);
      expect(provider.examHistory.length, 2);
      expect(provider.latestExamResult?.id, 'exam_2'); // Mới nhất lên đầu

      await provider.clearExamHistory();
      expect(provider.examHistory, isEmpty);
      expect(provider.latestExamResult, isNull);
    });

    test('resetAllData clears all bookmarks, wrong questions, and exam history', () async {
      await provider.toggleBookmark(1);
      await provider.addWrongQuestion(2);
      await provider.saveExamResult(
        ExamResult(
          id: 'exam_test',
          timestamp: 1000,
          score: 24,
          totalQuestions: 25,
          isPassed: true,
          isCriticalFailed: false,
          durationSeconds: 400,
          answers: {},
        ),
      );

      expect(provider.bookmarkedIds, isNotEmpty);
      expect(provider.wrongQuestionIds, isNotEmpty);
      expect(provider.examHistory, isNotEmpty);

      await provider.resetAllData();

      expect(provider.bookmarkedIds, isEmpty);
      expect(provider.wrongQuestionIds, isEmpty);
      expect(provider.examHistory, isEmpty);
    });
  });
}
