import 'package:flutter/foundation.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../exam/domain/exam_model.dart';

/// Provider quản lý dữ liệu người dùng (Bookmark, Sổ tay câu sai, Lịch sử thi, Cài đặt)
class UserDataProvider extends ChangeNotifier {
  final LocalStorageService _storageService;

  Set<int> _bookmarkedIds = {};
  Set<int> _wrongQuestionIds = {};
  List<ExamResult> _examHistory = [];
  String _fontSize = 'medium';
  bool _soundEnabled = true;
  bool _isInitialized = false;

  UserDataProvider(this._storageService) {
    loadData();
  }

  bool get isInitialized => _isInitialized;
  Set<int> get bookmarkedIds => _bookmarkedIds;
  Set<int> get wrongQuestionIds => _wrongQuestionIds;
  List<ExamResult> get examHistory => _examHistory;
  String get fontSize => _fontSize;
  bool get soundEnabled => _soundEnabled;

  ExamResult? get latestExamResult => _examHistory.isNotEmpty ? _examHistory.first : null;

  void loadData() {
    _bookmarkedIds = _storageService.getBookmarkedIds().toSet();
    _wrongQuestionIds = _storageService.getWrongQuestionIds().toSet();
    _fontSize = _storageService.getFontSize();
    _soundEnabled = _storageService.isSoundEnabled();

    final rawHistory = _storageService.getExamHistory();
    _examHistory = rawHistory.map((item) => ExamResult.fromJson(item)).toList();

    _isInitialized = true;
    notifyListeners();
  }

  bool isBookmarked(int questionId) {
    return _bookmarkedIds.contains(questionId);
  }

  Future<void> toggleBookmark(int questionId) async {
    final newState = await _storageService.toggleBookmark(questionId);
    if (newState) {
      _bookmarkedIds.add(questionId);
    } else {
      _bookmarkedIds.remove(questionId);
    }
    notifyListeners();
  }

  bool isWrong(int questionId) {
    return _wrongQuestionIds.contains(questionId);
  }

  Future<void> addWrongQuestion(int questionId) async {
    if (!_wrongQuestionIds.contains(questionId)) {
      _wrongQuestionIds.add(questionId);
      await _storageService.addWrongQuestion(questionId);
      notifyListeners();
    }
  }

  Future<void> removeWrongQuestion(int questionId) async {
    if (_wrongQuestionIds.contains(questionId)) {
      _wrongQuestionIds.remove(questionId);
      await _storageService.removeWrongQuestion(questionId);
      notifyListeners();
    }
  }

  Future<void> clearWrongQuestions() async {
    _wrongQuestionIds.clear();
    await _storageService.clearWrongQuestions();
    notifyListeners();
  }

  Future<void> saveExamResult(ExamResult result) async {
    _examHistory.insert(0, result);
    await _storageService.saveExamResult(result.toJson());
    notifyListeners();
  }

  Future<void> clearExamHistory() async {
    _examHistory.clear();
    await _storageService.clearExamHistory();
    notifyListeners();
  }

  Future<void> setFontSize(String size) async {
    _fontSize = size;
    await _storageService.setFontSize(size);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _storageService.setSoundEnabled(enabled);
    notifyListeners();
  }

  Future<void> resetAllData() async {
    _bookmarkedIds.clear();
    _wrongQuestionIds.clear();
    _examHistory.clear();
    await _storageService.resetAllUserData();
    notifyListeners();
  }
}
