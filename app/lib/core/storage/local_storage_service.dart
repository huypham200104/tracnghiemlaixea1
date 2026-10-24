import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Dịch vụ lưu trữ cục bộ 100% offline cho ứng dụng
class LocalStorageService {
  static const String _keyBookmarks = 'bookmarked_question_ids';
  static const String _keyWrongQuestions = 'wrong_question_ids';
  static const String _keyTopicProgress = 'topic_progress_map';
  static const String _keyExamHistory = 'exam_history_json_list';
  static const String _keyFontSize = 'app_font_size';
  static const String _keySoundEnabled = 'app_sound_enabled';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // MARK: - Bookmarks
  List<int> getBookmarkedIds() {
    final list = _prefs.getStringList(_keyBookmarks) ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toList();
  }

  bool isBookmarked(int questionId) {
    return getBookmarkedIds().contains(questionId);
  }

  Future<bool> toggleBookmark(int questionId) async {
    final current = getBookmarkedIds().toSet();
    final bool isNowBookmarked;
    if (current.contains(questionId)) {
      current.remove(questionId);
      isNowBookmarked = false;
    } else {
      current.add(questionId);
      isNowBookmarked = true;
    }
    await _prefs.setStringList(
      _keyBookmarks,
      current.map((e) => e.toString()).toList(),
    );
    return isNowBookmarked;
  }

  // MARK: - Wrong Questions Notebook
  List<int> getWrongQuestionIds() {
    final list = _prefs.getStringList(_keyWrongQuestions) ?? [];
    return list.map((e) => int.tryParse(e)).whereType<int>().toList();
  }

  Future<void> addWrongQuestion(int questionId) async {
    final current = getWrongQuestionIds().toSet();
    current.add(questionId);
    await _prefs.setStringList(
      _keyWrongQuestions,
      current.map((e) => e.toString()).toList(),
    );
  }

  Future<void> removeWrongQuestion(int questionId) async {
    final current = getWrongQuestionIds().toSet();
    current.remove(questionId);
    await _prefs.setStringList(
      _keyWrongQuestions,
      current.map((e) => e.toString()).toList(),
    );
  }

  Future<void> clearWrongQuestions() async {
    await _prefs.remove(_keyWrongQuestions);
  }

  // MARK: - Topic Progress
  Map<int, int> getTopicProgress() {
    final raw = _prefs.getString(_keyTopicProgress);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(int.parse(key), value as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveTopicProgress(int topicId, int answeredCount) async {
    final current = getTopicProgress();
    current[topicId] = answeredCount;
    final encoded = jsonEncode(
      current.map((key, value) => MapEntry(key.toString(), value)),
    );
    await _prefs.setString(_keyTopicProgress, encoded);
  }

  // MARK: - Exam History
  List<Map<String, dynamic>> getExamHistory() {
    final rawList = _prefs.getStringList(_keyExamHistory) ?? [];
    final List<Map<String, dynamic>> results = [];
    for (final item in rawList) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        results.add(decoded);
      } catch (_) {}
    }
    // Sắp xếp mới nhất lên đầu
    results.sort((a, b) {
      final timeA = a['timestamp'] as int? ?? 0;
      final timeB = b['timestamp'] as int? ?? 0;
      return timeB.compareTo(timeA);
    });
    return results;
  }

  Future<void> saveExamResult(Map<String, dynamic> resultJson) async {
    final currentRaw = _prefs.getStringList(_keyExamHistory) ?? [];
    currentRaw.add(jsonEncode(resultJson));
    await _prefs.setStringList(_keyExamHistory, currentRaw);
  }

  Future<void> clearExamHistory() async {
    await _prefs.remove(_keyExamHistory);
  }

  // MARK: - Settings
  String getFontSize() {
    return _prefs.getString(_keyFontSize) ?? 'medium';
  }

  Future<void> setFontSize(String size) async {
    await _prefs.setString(_keyFontSize, size);
  }

  bool isSoundEnabled() {
    return _prefs.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_keySoundEnabled, enabled);
  }

  Future<void> resetAllUserData() async {
    await _prefs.remove(_keyBookmarks);
    await _prefs.remove(_keyWrongQuestions);
    await _prefs.remove(_keyTopicProgress);
    await _prefs.remove(_keyExamHistory);
  }
}
