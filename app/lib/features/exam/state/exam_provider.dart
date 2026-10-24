import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../study/domain/question_model.dart';
import '../domain/exam_model.dart';
import '../../profile/state/user_data_provider.dart';

/// Provider quản lý toàn bộ vòng đời và nghiệp vụ chấm điểm của bài thi sát hạch A1
class ExamProvider extends ChangeNotifier {
  final UserDataProvider? _userDataProvider;

  List<Question> _questions = [];
  final Map<int, int?> _answers = {}; // questionId -> selectedIndex
  int _currentIndex = 0;
  int _remainingSeconds = AppConstants.examDurationSeconds;
  Timer? _timer;
  bool _isSubmitted = false;
  ExamResult? _latestResult;

  ExamProvider([this._userDataProvider]);

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get remainingSeconds => _remainingSeconds;
  bool get isSubmitted => _isSubmitted;
  ExamResult? get latestResult => _latestResult;
  int get totalQuestions => _questions.length;

  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  int? get currentAnswer =>
      currentQuestion != null ? _answers[currentQuestion!.id] : null;

  int get answeredCount =>
      _answers.values.where((ans) => ans != null).length;

  int get unansweredCount => totalQuestions - answeredCount;

  bool isQuestionAnswered(int index) {
    if (index < 0 || index >= _questions.length) return false;
    final q = _questions[index];
    return _answers[q.id] != null;
  }

  int? getAnswerForQuestion(int questionId) => _answers[questionId];

  /// Bắt đầu tạo bài thi mới 25 câu hỏi
  void startExam(List<Question> allQuestions, {bool shuffle = true}) {
    _timer?.cancel();
    _answers.clear();
    _currentIndex = 0;
    _remainingSeconds = AppConstants.examDurationSeconds;
    _isSubmitted = false;
    _latestResult = null;

    if (allQuestions.length <= AppConstants.examQuestionCount) {
      _questions = List.from(allQuestions);
      if (shuffle) _questions.shuffle(Random());
    } else {
      // Đảm bảo có câu điểm liệt trong đề thi
      final critical = allQuestions.where((q) => q.isCritical).toList();
      final normal = allQuestions.where((q) => !q.isCritical).toList();

      if (shuffle) {
        critical.shuffle(Random());
        normal.shuffle(Random());
      }

      // Lấy 2-4 câu điểm liệt, còn lại là câu thường
      final pickCritical = critical.take(3).toList();
      final pickNormal = normal.take(AppConstants.examQuestionCount - pickCritical.length).toList();

      _questions = [...pickCritical, ...pickNormal];
      if (shuffle) _questions.shuffle(Random());
    }

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        submitExam();
      }
    });
  }

  void selectAnswer(int optionIndex) {
    if (_isSubmitted || currentQuestion == null) return;
    _answers[currentQuestion!.id] = optionIndex;
    notifyListeners();
  }

  void selectAnswerForQuestion(int questionId, int optionIndex) {
    if (_isSubmitted) return;
    _answers[questionId] = optionIndex;
    notifyListeners();
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// Nộp bài thi và thực hiện chấm điểm theo quy tắc sát hạch Bộ GTVT
  ExamResult submitExam() {
    _timer?.cancel();
    _isSubmitted = true;

    int correctCount = 0;
    bool hasCriticalFailed = false;

    for (final q in _questions) {
      final selected = _answers[q.id];
      final isCorrect = selected != null && selected == q.correctIndex;

      if (isCorrect) {
        correctCount++;
      } else {
        // Nếu câu điểm liệt trả lời sai hoặc chưa làm -> Bị trượt
        if (q.isCritical) {
          hasCriticalFailed = true;
        }
        // Tự động đẩy câu sai vào sổ tay
        if (selected != null && selected != q.correctIndex) {
          _userDataProvider?.addWrongQuestion(q.id);
        }
      }
    }

    // Quy tắc: ĐẠT khi >= 21/25 VÀ không sai câu điểm liệt
    final bool isPassed =
        (correctCount >= AppConstants.passingScore) && !hasCriticalFailed;

    final durationUsed = AppConstants.examDurationSeconds - _remainingSeconds;

    final result = ExamResult(
      id: 'exam_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      score: correctCount,
      totalQuestions: _questions.length,
      isPassed: isPassed,
      isCriticalFailed: hasCriticalFailed,
      durationSeconds: durationUsed > 0 ? durationUsed : 0,
      answers: Map.from(_answers),
    );

    _latestResult = result;
    _userDataProvider?.saveExamResult(result);

    notifyListeners();
    return result;
  }

  void cancelExam() {
    _timer?.cancel();
    _isSubmitted = false;
    _answers.clear();
    _questions.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
