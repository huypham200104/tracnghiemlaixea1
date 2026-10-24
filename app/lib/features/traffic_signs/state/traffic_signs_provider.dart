import 'package:flutter/foundation.dart';
import '../../study/data/question_repository.dart';
import '../domain/traffic_sign_model.dart';

/// Provider quản lý danh mục biển báo giao thông, lọc theo nhóm và tìm kiếm
class TrafficSignsProvider extends ChangeNotifier {
  final QuestionRepository _repository;

  List<TrafficSign> _allSigns = [];
  String _selectedGroup = 'all'; // all, cam, hieulenh, nguyhiem, chidan, phu
  String _searchQuery = '';
  bool _isLoading = false;

  TrafficSignsProvider(this._repository) {
    loadSigns();
  }

  bool get isLoading => _isLoading;
  String get selectedGroup => _selectedGroup;
  String get searchQuery => _searchQuery;

  List<TrafficSign> get filteredSigns {
    return _allSigns.where((sign) {
      // Lọc theo nhóm hoặc chế độ thi A1
      if (_selectedGroup == 'exam') {
        if (!sign.isInExam) return false;
      } else if (_selectedGroup != 'all' && sign.group != _selectedGroup) {
        return false;
      }

      // Lọc theo tìm kiếm thông minh: mã, tên, mô tả và mẹo thi
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final queryClean = query.replaceAll('.', '').replaceAll(' ', '');
        final signCodeClean = sign.code.toLowerCase().replaceAll('.', '').replaceAll(' ', '');

        final matchCode = sign.code.toLowerCase().contains(query) || signCodeClean.contains(queryClean);
        final matchName = sign.name.toLowerCase().contains(query);
        final matchDesc = sign.description.toLowerCase().contains(query);
        final matchTips = sign.tips?.toLowerCase().contains(query) ?? false;

        return matchCode || matchName || matchDesc || matchTips;
      }
      return true;
    }).toList();
  }

  Future<void> loadSigns() async {
    _isLoading = true;
    notifyListeners();

    _allSigns = await _repository.loadTrafficSigns();

    _isLoading = false;
    notifyListeners();
  }

  void selectGroup(String group) {
    if (_selectedGroup != group) {
      _selectedGroup = group;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
