import 'package:flutter/foundation.dart';
import '../data/question_repository.dart';
import '../domain/question_model.dart';
import '../domain/topic_model.dart';
import '../../../core/storage/local_storage_service.dart';

/// Provider quản lý ngân hàng câu hỏi và tiến độ ôn tập theo 5 chương
class StudyProvider extends ChangeNotifier {
  final QuestionRepository _repository;
  final LocalStorageService _storageService;

  List<Question> _questions = [];
  bool _isLoading = false;
  Map<int, int> _topicProgress = {};

  StudyProvider(this._repository, this._storageService) {
    loadQuestions();
  }

  bool get isLoading => _isLoading;
  List<Question> get questions => _questions;
  int get totalQuestions => _questions.length;

  List<Question> get criticalQuestions =>
      _questions.where((q) => q.isCritical).toList();

  List<Topic> get topics => Topic.defaultTopics;

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();

    _questions = await _repository.loadQuestions();
    _topicProgress = _storageService.getTopicProgress();

    _isLoading = false;
    notifyListeners();
  }

  List<Question> getQuestionsByTopic(int topicId) {
    return _questions.where((q) => q.topicId == topicId).toList();
  }

  List<Question> getQuestionsByIds(Iterable<int> ids) {
    final idSet = ids.toSet();
    return _questions.where((q) => idSet.contains(q.id)).toList();
  }

  int getTopicCompletedCount(int topicId) {
    return _topicProgress[topicId] ?? 0;
  }

  Future<void> updateTopicProgress(int topicId, int completedCount) async {
    _topicProgress[topicId] = completedCount;
    await _storageService.saveTopicProgress(topicId, completedCount);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _topicProgress.clear();
    notifyListeners();
  }
}
