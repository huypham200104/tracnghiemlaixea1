import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/constants/app_assets.dart';
import '../domain/question_model.dart';
import '../../traffic_signs/domain/traffic_sign_model.dart';

/// Repository nạp dữ liệu offline từ assets bundle
class QuestionRepository {
  List<Question>? _cachedQuestions;
  List<TrafficSign>? _cachedTrafficSigns;

  Future<List<Question>> loadQuestions({AssetBundle? bundle}) async {
    if (_cachedQuestions != null && _cachedQuestions!.isNotEmpty) {
      return _cachedQuestions!;
    }

    final assetBundle = bundle ?? rootBundle;
    try {
      final jsonString = await assetBundle.loadString(AppAssets.questionsJson);
      final list = jsonDecode(jsonString) as List;
      _cachedQuestions = list
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cachedQuestions!;
    } catch (e) {
      return [];
    }
  }

  Future<List<TrafficSign>> loadTrafficSigns({AssetBundle? bundle}) async {
    if (_cachedTrafficSigns != null && _cachedTrafficSigns!.isNotEmpty) {
      return _cachedTrafficSigns!;
    }

    final assetBundle = bundle ?? rootBundle;
    try {
      final jsonString = await assetBundle.loadString(AppAssets.trafficSignsJson);
      final list = jsonDecode(jsonString) as List;
      _cachedTrafficSigns = list
          .map((item) => TrafficSign.fromJson(item as Map<String, dynamic>))
          .toList();
      return _cachedTrafficSigns!;
    } catch (e) {
      return [];
    }
  }

  List<Question> get cachedQuestions => _cachedQuestions ?? [];
}
