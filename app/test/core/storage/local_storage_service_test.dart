import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/storage/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = await LocalStorageService.create();
  });

  group('LocalStorageService Bookmarks', () {
    test('starts with empty bookmarks and toggles correctly', () async {
      expect(storageService.getBookmarkedIds(), isEmpty);
      expect(storageService.isBookmarked(1), isFalse);

      final isBookmarked = await storageService.toggleBookmark(1);
      expect(isBookmarked, isTrue);
      expect(storageService.isBookmarked(1), isTrue);
      expect(storageService.getBookmarkedIds(), [1]);

      final isRemoved = await storageService.toggleBookmark(1);
      expect(isRemoved, isFalse);
      expect(storageService.isBookmarked(1), isFalse);
      expect(storageService.getBookmarkedIds(), isEmpty);
    });
  });

  group('LocalStorageService Wrong Questions', () {
    test('adds, checks, and removes wrong questions', () async {
      expect(storageService.getWrongQuestionIds(), isEmpty);

      await storageService.addWrongQuestion(5);
      await storageService.addWrongQuestion(10);
      expect(storageService.getWrongQuestionIds(), containsAll([5, 10]));

      await storageService.removeWrongQuestion(5);
      expect(storageService.getWrongQuestionIds(), [10]);

      await storageService.clearWrongQuestions();
      expect(storageService.getWrongQuestionIds(), isEmpty);
    });
  });

  group('LocalStorageService Exam History', () {
    test('saves and retrieves exam result sorted by timestamp descending', () async {
      expect(storageService.getExamHistory(), isEmpty);

      await storageService.saveExamResult({
        'id': 'exam_1',
        'timestamp': 1000,
        'score': 20,
        'isPassed': false,
      });

      await storageService.saveExamResult({
        'id': 'exam_2',
        'timestamp': 2000,
        'score': 23,
        'isPassed': true,
      });

      final history = storageService.getExamHistory();
      expect(history.length, 2);
      expect(history[0]['id'], 'exam_2'); // Mới nhất lên đầu
      expect(history[1]['id'], 'exam_1');
    });
  });

  group('LocalStorageService Reset All Data', () {
    test('clears bookmarks, wrong questions, topic progress, and exam history', () async {
      await storageService.toggleBookmark(1);
      await storageService.addWrongQuestion(2);
      await storageService.saveTopicProgress(1, 15);
      await storageService.saveExamResult({'id': 'exam_1', 'timestamp': 1000});

      expect(storageService.getBookmarkedIds(), [1]);
      expect(storageService.getWrongQuestionIds(), [2]);
      expect(storageService.getTopicProgress()[1], 15);
      expect(storageService.getExamHistory(), isNotEmpty);

      await storageService.resetAllUserData();

      expect(storageService.getBookmarkedIds(), isEmpty);
      expect(storageService.getWrongQuestionIds(), isEmpty);
      expect(storageService.getTopicProgress(), isEmpty);
      expect(storageService.getExamHistory(), isEmpty);
    });
  });
}
