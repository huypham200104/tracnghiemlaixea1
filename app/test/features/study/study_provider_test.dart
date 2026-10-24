import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/storage/local_storage_service.dart';
import 'package:app/features/study/data/question_repository.dart';
import 'package:app/features/study/state/study_provider.dart';

class MockStudyAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return jsonEncode([
      {
        'id': 1,
        'topicId': 1,
        'content': 'Question 1',
        'options': ['A', 'B'],
        'correctIndex': 0,
        'isCritical': true,
        'explanation': 'Exp 1'
      },
      {
        'id': 2,
        'topicId': 1,
        'content': 'Question 2',
        'options': ['A', 'B'],
        'correctIndex': 1,
        'isCritical': false,
        'explanation': 'Exp 2'
      },
      {
        'id': 3,
        'topicId': 2,
        'content': 'Question 3',
        'options': ['A', 'B'],
        'correctIndex': 0,
        'isCritical': false,
        'explanation': 'Exp 3'
      },
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StudyProvider Tests', () {
    late LocalStorageService storageService;
    late QuestionRepository repository;
    late StudyProvider studyProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await LocalStorageService.create();
      repository = QuestionRepository();
    });

    test('loads questions and parses correctly', () async {
      // Load questions using mock bundle
      final questions = await repository.loadQuestions(bundle: MockStudyAssetBundle());
      expect(questions.length, 3);

      studyProvider = StudyProvider(repository, storageService);
      // Wait for async load if needed or invoke load
      expect(studyProvider.topics.length, 5);
    });

    test('getQuestionsByTopic filters correctly', () async {
      final mockBundle = MockStudyAssetBundle();
      await repository.loadQuestions(bundle: mockBundle);
      studyProvider = StudyProvider(repository, storageService);
      await studyProvider.loadQuestions();

      final topic1Questions = studyProvider.getQuestionsByTopic(1);
      expect(topic1Questions.length, 2);
      expect(topic1Questions.every((q) => q.topicId == 1), isTrue);

      final topic2Questions = studyProvider.getQuestionsByTopic(2);
      expect(topic2Questions.length, 1);
      expect(topic2Questions.first.id, 3);
    });

    test('criticalQuestions filters only critical questions', () async {
      await repository.loadQuestions(bundle: MockStudyAssetBundle());
      studyProvider = StudyProvider(repository, storageService);
      await studyProvider.loadQuestions();

      expect(studyProvider.criticalQuestions.length, 1);
      expect(studyProvider.criticalQuestions.first.id, 1);
      expect(studyProvider.criticalQuestions.first.isCritical, isTrue);
    });

    test('updateTopicProgress and resetProgress', () async {
      studyProvider = StudyProvider(repository, storageService);

      expect(studyProvider.getTopicCompletedCount(1), 0);

      await studyProvider.updateTopicProgress(1, 15);
      expect(studyProvider.getTopicCompletedCount(1), 15);

      await studyProvider.resetProgress();
      expect(studyProvider.getTopicCompletedCount(1), 0);
    });
  });
}
