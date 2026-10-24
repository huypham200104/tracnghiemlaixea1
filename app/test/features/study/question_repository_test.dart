import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/study/data/question_repository.dart';
import 'package:app/features/study/domain/question_model.dart';
import 'package:app/features/traffic_signs/domain/traffic_sign_model.dart';

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.contains('questions')) {
      return jsonEncode([
        {
          'id': 1,
          'topicId': 1,
          'content': 'Test question 1',
          'options': ['Opt A', 'Opt B', 'Opt C'],
          'correctIndex': 0,
          'isCritical': true,
          'image': null,
          'explanation': 'Test explanation'
        }
      ]);
    } else if (key.contains('traffic_signs')) {
      return jsonEncode([
        {
          'code': 'P.101',
          'name': 'Đường cấm',
          'group': 'cam',
          'image': null,
          'description': 'Đường cấm tất cả phương tiện'
        }
      ]);
    }
    throw Exception('Asset not found');
  }
}

void main() {
  group('QuestionRepository Tests', () {
    late QuestionRepository repository;
    late MockAssetBundle mockBundle;

    setUp(() {
      repository = QuestionRepository();
      mockBundle = MockAssetBundle();
    });

    test('loads questions and parses correctly', () async {
      final questions = await repository.loadQuestions(bundle: mockBundle);
      expect(questions.length, 1);
      final q = questions.first;
      expect(q.id, 1);
      expect(q.isCritical, isTrue);
      expect(q.options.length, 3);
      expect(q.correctIndex, 0);
    });

    test('loads traffic signs and parses correctly', () async {
      final signs = await repository.loadTrafficSigns(bundle: mockBundle);
      expect(signs.length, 1);
      final sign = signs.first;
      expect(sign.code, 'P.101');
      expect(sign.groupName, 'Biển báo cấm');
    });
  });

  group('200 Questions A1 Official Data Integrity Verification', () {
    late List<Question> allQuestions;

    setUpAll(() {
      final jsonFile = File('assets/data/questions_a1.json');
      expect(jsonFile.existsSync(), isTrue, reason: 'questions_a1.json must exist');
      final content = jsonFile.readAsStringSync();
      final List<dynamic> raw = jsonDecode(content);
      allQuestions = raw.map((item) => Question.fromJson(item as Map<String, dynamic>)).toList();
    });

    test('contains exactly 200 questions', () {
      expect(allQuestions.length, 200);
    });

    test('all question IDs are unique and numbered from 1 to 200', () {
      final ids = allQuestions.map((q) => q.id).toSet();
      expect(ids.length, 200);
      for (int i = 1; i <= 200; i++) {
        expect(ids.contains(i), isTrue, reason: 'Question ID $i must exist');
      }
    });

    test('contains exactly 20 critical questions (câu điểm liệt)', () {
      final criticals = allQuestions.where((q) => q.isCritical).toList();
      expect(criticals.length, 20);
    });

    test('topic distribution adheres to Ministry of Transport standard', () {
      final topic1 = allQuestions.where((q) => q.topicId == 1).length;
      final topic2 = allQuestions.where((q) => q.topicId == 2).length;
      final topic3 = allQuestions.where((q) => q.topicId == 3).length;
      final topic4 = allQuestions.where((q) => q.topicId == 4).length;
      final topic5 = allQuestions.where((q) => q.topicId == 5).length;

      expect(topic1, 83, reason: 'Topic 1: Khái niệm & quy tắc phải có 83 câu');
      expect(topic2, 5, reason: 'Topic 2: Văn hóa & đạo đức phải có 5 câu');
      expect(topic3, 12, reason: 'Topic 3: Kỹ thuật lái xe phải có 12 câu');
      expect(topic4, 65, reason: 'Topic 4: Biển báo phải có 65 câu');
      expect(topic5, 35, reason: 'Topic 5: Sa hình phải có 35 câu');
    });

    test('all correctIndex are within valid range of options', () {
      for (final q in allQuestions) {
        expect(q.options.isNotEmpty, isTrue);
        expect(
          q.correctIndex >= 0 && q.correctIndex < q.options.length,
          isTrue,
          reason: 'Question ${q.id} has invalid correctIndex: ${q.correctIndex}',
        );
      }
    });
  });

  group('Traffic Signs Data Integrity Verification', () {
    late List<TrafficSign> allSigns;

    setUpAll(() {
      final jsonFile = File('assets/data/traffic_signs.json');
      expect(jsonFile.existsSync(), isTrue, reason: 'traffic_signs.json must exist');
      final content = jsonFile.readAsStringSync();
      final List<dynamic> raw = jsonDecode(content);
      allSigns = raw.map((item) => TrafficSign.fromJson(item as Map<String, dynamic>)).toList();
    });

    test('contains comprehensive collection of traffic signs', () {
      expect(allSigns.length >= 40, isTrue);
    });

    test('contains all 5 standard groups', () {
      final groups = allSigns.map((s) => s.group).toSet();
      expect(groups.contains('cam'), isTrue);
      expect(groups.contains('hieulenh'), isTrue);
      expect(groups.contains('nguyhiem'), isTrue);
      expect(groups.contains('chidan'), isTrue);
      expect(groups.contains('phu'), isTrue);
    });

    test('each sign has non-empty code, name, and description', () {
      for (final sign in allSigns) {
        expect(sign.code.isNotEmpty, isTrue);
        expect(sign.name.isNotEmpty, isTrue);
        expect(sign.description.isNotEmpty, isTrue);
      }
    });
  });

  group('Question Model copyWith and JSON', () {
    test('serializes and deserializes cleanly', () {
      const q = Question(
        id: 10,
        topicId: 2,
        content: 'Sample',
        options: ['1', '2'],
        correctIndex: 1,
        isCritical: false,
        explanation: 'Exp',
      );

      final json = q.toJson();
      final parsed = Question.fromJson(json);
      expect(parsed.id, 10);
      expect(parsed.content, 'Sample');
      expect(parsed.correctIndex, 1);

      final copy = q.copyWith(isCritical: true);
      expect(copy.isCritical, isTrue);
      expect(copy.id, 10);
    });
  });
}
