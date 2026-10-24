import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/study/data/question_repository.dart';
import 'package:app/features/traffic_signs/domain/traffic_sign_model.dart';
import 'package:app/features/traffic_signs/state/traffic_signs_provider.dart';

class MockSignAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.contains('traffic_signs')) {
      return jsonEncode([
        {
          'code': 'P.101',
          'name': 'Đường cấm',
          'group': 'cam',
          'image': 'assets/images/signs/P_101.png',
          'description': 'Đường cấm tất cả phương tiện',
          'is_in_exam': true,
          'tips': 'Cấm tuyệt đối mọi loại xe'
        },
        {
          'code': 'P.103a',
          'name': 'Cấm xe ô tô',
          'group': 'cam',
          'image': 'assets/images/signs/P_103a.png',
          'description': 'Báo đường cấm ô tô',
          'is_in_exam': true,
          'tips': 'Không cấm xe mô tô hai bánh'
        },
        {
          'code': 'W.201a',
          'name': 'Chỗ ngoặt nguy hiểm vòng bên trái',
          'group': 'nguyhiem',
          'image': 'assets/images/signs/W_201a.png',
          'description': 'Chỗ ngoặt nguy hiểm bên trái',
          'is_in_exam': false,
          'tips': null
        },
        {
          'code': 'R.301a',
          'name': 'Hướng đi phải theo',
          'group': 'hieulenh',
          'image': 'assets/images/signs/R_301a.png',
          'description': 'Chỉ được đi thẳng',
          'is_in_exam': true,
          'tips': 'Bắt buộc đi thẳng'
        }
      ]);
    }
    throw Exception('Asset not found');
  }
}

class FakeQuestionRepository extends QuestionRepository {
  final AssetBundle bundle;
  FakeQuestionRepository(this.bundle);

  @override
  Future<List<TrafficSign>> loadTrafficSigns({AssetBundle? bundle}) {
    return super.loadTrafficSigns(bundle: this.bundle);
  }
}

void main() {
  group('TrafficSign Model Tests', () {
    test('parses from JSON correctly with new fields', () {
      final json = {
        'code': 'P.104',
        'name': 'Cấm xe mô tô',
        'group': 'cam',
        'image': 'assets/images/signs/P_104.png',
        'description': 'Cấm mô tô',
        'is_in_exam': true,
        'tips': 'Không cấm xe gắn máy'
      };

      final sign = TrafficSign.fromJson(json);
      expect(sign.code, 'P.104');
      expect(sign.name, 'Cấm xe mô tô');
      expect(sign.group, 'cam');
      expect(sign.groupName, 'Biển báo cấm');
      expect(sign.isInExam, isTrue);
      expect(sign.tips, 'Không cấm xe gắn máy');

      final serialized = sign.toJson();
      expect(serialized['is_in_exam'], isTrue);
      expect(serialized['tips'], 'Không cấm xe gắn máy');
    });

    test('copyWith works properly', () {
      const sign = TrafficSign(
        code: 'P.101',
        name: 'Đường cấm',
        group: 'cam',
        description: 'Mô tả',
        isInExam: false,
      );

      final updated = sign.copyWith(isInExam: true, tips: 'Mẹo nhớ');
      expect(updated.code, 'P.101');
      expect(updated.isInExam, isTrue);
      expect(updated.tips, 'Mẹo nhớ');
    });
  });

  group('TrafficSignsProvider Tests', () {
    late FakeQuestionRepository repository;
    late TrafficSignsProvider provider;

    setUp(() async {
      repository = FakeQuestionRepository(MockSignAssetBundle());
      provider = TrafficSignsProvider(repository);
      await provider.loadSigns();
    });

    test('initial state loads all signs', () {
      expect(provider.filteredSigns.length, 4);
    });

    test('filters by group correctly', () {
      provider.selectGroup('cam');
      expect(provider.filteredSigns.length, 2);
      expect(provider.filteredSigns.every((s) => s.group == 'cam'), isTrue);

      provider.selectGroup('nguyhiem');
      expect(provider.filteredSigns.length, 1);
      expect(provider.filteredSigns.first.code, 'W.201a');
    });

    test('filters by exam mode (⭐ Đề thi A1) correctly', () {
      provider.selectGroup('exam');
      expect(provider.filteredSigns.length, 3);
      expect(provider.filteredSigns.every((s) => s.isInExam), isTrue);
      expect(provider.filteredSigns.any((s) => s.code == 'W.201a'), isFalse);
    });

    test('smart search by code (with or without dot)', () {
      provider.setSearchQuery('p101');
      expect(provider.filteredSigns.length, 1);
      expect(provider.filteredSigns.first.code, 'P.101');

      provider.setSearchQuery('P.103a');
      expect(provider.filteredSigns.length, 1);
      expect(provider.filteredSigns.first.code, 'P.103a');
    });

    test('smart search by name', () {
      provider.setSearchQuery('ngoặt nguy hiểm');
      expect(provider.filteredSigns.length, 1);
      expect(provider.filteredSigns.first.code, 'W.201a');
    });

    test('smart search by tips and description', () {
      provider.setSearchQuery('hai bánh');
      expect(provider.filteredSigns.length, 1);
      expect(provider.filteredSigns.first.code, 'P.103a');
    });

    test('clear search restores filter list', () {
      provider.setSearchQuery('xyz123');
      expect(provider.filteredSigns, isEmpty);

      provider.clearSearch();
      expect(provider.filteredSigns.length, 4);
    });
  });
}
