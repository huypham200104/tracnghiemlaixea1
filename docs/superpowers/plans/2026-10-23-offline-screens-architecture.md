# Triển khai hệ thống màn hình & Lưu trữ dữ liệu Offline — Trắc Nghiệm Lái Xe A1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Xây dựng hệ thống màn hình chuẩn Material 3 (Navigation Shell 4 tab + luồng Thi sát hạch 25 câu 19 phút) và cơ chế lưu trữ dữ liệu 100% offline cho ứng dụng Flutter Trắc Nghiệm Lái Xe A1.

**Architecture:** Áp dụng Feature-first Clean Architecture, tách bạch giữa core/ (theme, storage, widgets), domain models, providers (quản lý state phản ứng) và presentation screens.

**Tech Stack:** Flutter 3.8+ (Dart 3+), Provider 6.1+, SharedPreferences 2.5+, PathProvider 2.1+, Material 3.

**Spec:** [2026-10-23-offline-screens-architecture-design.md](file:///c:/Workplace/GitHub/tracnghiemlaixea1/docs/superpowers/specs/2026-10-23-offline-screens-architecture-design.md)

## Global Constraints

- 100% Offline: Không thêm bất kỳ package mạng nào (`http`, `dio`, analytics...).
- Strict Null Safety: Dart 3+, không dùng `dynamic`, dùng `const` constructor tối đa.
- Design Tokens: Tuân thủ bảng màu ngữ nghĩa giao thông (`#1565C0` Primary, `#2E7D32` Success, `#C62828` Error, `#EF6C00` Warning) theo `DESIGN.md`.
- Git Policy: Chỉ dùng read-only git command; không chạy git commit tự động nếu chưa có sự đồng ý.

## Review Focus

1. Điểm liệt thi sát hạch: Nếu sai bất kỳ 1 câu điểm liệt, kết quả thi PHẢI là TRƯỢT ngay cả khi đúng 24/25 câu.
2. Hết giờ làm bài: Khi timer 19:00 đếm về 0, hệ thống phải tự động nộp bài và khóa chỉnh sửa đáp án.
3. Thoát bài thi: Người dùng bấm back/thoát bài thi phải có dialog cảnh báo bài làm sẽ bị hủy.
4. Đọc dữ liệu JSON: Bộ nạp câu hỏi và biển báo phải xử lý fallback an toàn khi file rỗng hoặc lỗi parse.
5. Cập nhật tiến độ: Sau khi nộp bài thi, lịch sử và câu sai phải được ghi nhận vào `LocalStorageService` ngay lập tức.

---

### Task 1: Cấu hình dependencies và nạp dữ liệu Assets ban đầu

**Files:**
- Modify: `app/pubspec.yaml`
- Create: `app/assets/data/questions_a1.json`
- Create: `app/assets/data/traffic_signs.json`

**Interfaces:**
- Produces: `questions_a1.json` (25+ câu hỏi mẫu chuẩn Bộ GTVT đủ 5 chương, có câu điểm liệt), `traffic_signs.json` (danh mục biển báo chuẩn theo 5 nhóm).

- [ ] **Step 1: Cập nhật `app/pubspec.yaml`**
Thêm `provider: ^6.1.2`, `shared_preferences: ^2.5.2`, `path_provider: ^2.1.5` vào `dependencies`. Khai báo thư mục `assets/data/` trong mục `flutter: assets:`.
- [ ] **Step 2: Tạo `app/assets/data/questions_a1.json`**
Chứa 25 câu hỏi mẫu thực tế từ bộ đề 200 câu A1, đầy đủ các trường: `id`, `topicId` (1..5), `content`, `options`, `correctIndex`, `isCritical`, `explanation`.
- [ ] **Step 3: Tạo `app/assets/data/traffic_signs.json`**
Chứa danh mục các biển báo phổ biến thuộc 5 nhóm: `cam`, `hieulenh`, `nguyhiem`, `chidan`, `phu`.
- [ ] **Step 4: Chạy lệnh `flutter pub get`**
Run: `flutter pub get` (trong thư mục `c:\Workplace\GitHub\tracnghiemlaixea1\app`).
Expected: Chạy thành công và nạp đầy đủ dependencies.

---

### Task 2: Xây dựng Core Constants, Theme Tokens & Typography (Material 3)

**Files:**
- Create: `app/lib/core/constants/app_constants.dart`
- Create: `app/lib/core/constants/app_assets.dart`
- Create: `app/lib/core/theme/app_colors.dart`
- Create: `app/lib/core/theme/app_typography.dart`
- Create: `app/lib/core/theme/app_theme.dart`

**Interfaces:**
- Produces: `AppConstants` (examDurationMinutes = 19, totalExamQuestions = 25, passScoreThreshold = 21), `AppColors` (primary, success, error, warning, canvas, surface), `AppTheme.lightTheme`.

- [ ] **Step 1: Viết `app_constants.dart` và `app_assets.dart`**
Định nghĩa hằng số nghiệp vụ sát hạch A1 và đường dẫn assets.
- [ ] **Step 2: Viết `app_colors.dart`**
Định nghĩa màu sắc theo chuẩn Design System: `#1565C0` (Primary), `#2E7D32` (Success), `#C62828` (Error), `#EF6C00` (Warning), `#F6F7FB` (Canvas), `#FFFFFF` (Surface).
- [ ] **Step 3: Viết `app_typography.dart` và `app_theme.dart`**
Cấu hình TextStyle chuẩn Material 3 và ThemeData với `useMaterial3: true`, cardTheme bo góc 12dp, navigationBarTheme thanh lịch.
- [ ] **Step 4: Kiểm tra phân tích tĩnh**
Run: `flutter analyze`
Expected: 0 errors.

---

### Task 3: Xây dựng Service Lưu trữ Cục bộ (LocalStorageService)

**Files:**
- Create: `app/lib/core/storage/local_storage_service.dart`
- Create: `app/test/core/storage/local_storage_service_test.dart`

**Interfaces:**
- Produces: `LocalStorageService`:
  - `Future<void> init()`
  - `List<int> getBookmarkedIds()`, `Future<void> toggleBookmark(int id)`
  - `List<int> getWrongQuestionIds()`, `Future<void> addWrongQuestion(int id)`
  - `Future<void> saveExamResult(Map<String, dynamic> resultJson)`
  - `Future<List<Map<String, dynamic>>> getExamHistory()`

- [ ] **Step 1: Viết Unit Test cho LocalStorageService**
Kiểm tra lưu và lấy bookmark, danh sách câu sai.
- [ ] **Step 2: Cài đặt `LocalStorageService`**
Sử dụng `SharedPreferences` cho settings/bookmarks/wrong IDs và lưu trữ lịch sử thi dạng JSON.
- [ ] **Step 3: Chạy Unit Test**
Run: `flutter test test/core/storage/local_storage_service_test.dart`
Expected: PASS.

---

### Task 4: Xây dựng Domain Models & Repository nạp dữ liệu

**Files:**
- Create: `app/lib/features/study/domain/question_model.dart`
- Create: `app/lib/features/study/domain/topic_model.dart`
- Create: `app/lib/features/traffic_signs/domain/traffic_sign_model.dart`
- Create: `app/lib/features/exam/domain/exam_model.dart`
- Create: `app/lib/features/study/data/question_repository.dart`

**Interfaces:**
- Produces:
  - `Question` class (id, topicId, content, options, correctIndex, isCritical, explanation)
  - `Topic` class (id, name, totalQuestions, criticalQuestionsCount)
  - `TrafficSign` class (code, name, group, description)
  - `ExamResult` class (id, timestamp, score, isPassed, isCriticalFailed, durationSeconds, answers)
  - `QuestionRepository.loadQuestions()`, `QuestionRepository.loadTrafficSigns()`

- [ ] **Step 1: Viết test cho `QuestionRepository`**
Test nạp JSON từ assets và parse đúng danh sách câu hỏi.
- [ ] **Step 2: Cài đặt các data models với `fromJson`, `toJson`**
- [ ] **Step 3: Cài đặt `QuestionRepository` nạp dữ liệu từ `rootBundle`**
- [ ] **Step 4: Chạy test repository**
Run: `flutter test`
Expected: PASS.

---

### Task 5: Xây dựng Core UI Reusable Widgets

**Files:**
- Create: `app/lib/core/widgets/app_button.dart`
- Create: `app/lib/core/widgets/status_badge.dart`
- Create: `app/lib/core/widgets/timer_widget.dart`
- Create: `app/lib/core/widgets/question_card.dart`

**Interfaces:**
- Produces:
  - `AppButton`: Button tùy chỉnh M3 (Primary, Outlined, Danger).
  - `StatusBadge`: Badge ĐẠT / TRƯỢT / CÂU ĐIỂM LIỆT / ĐÃ TRẢ LỜI.
  - `TimerWidget`: Đồng hồ đếm ngược format `mm:ss`, đổi màu đỏ khi ≤ 5 phút.
  - `QuestionCard`: Hiển thị nội dung câu hỏi và các lựa chọn A, B, C, D (hỗ trợ chế độ thi và chế độ xem lại giải thích).

- [ ] **Step 1: Cài đặt `app_button.dart` và `status_badge.dart`**
- [ ] **Step 2: Cài đặt `timer_widget.dart`**
- [ ] **Step 3: Cài đặt `question_card.dart`**
- [ ] **Step 4: Chạy `flutter analyze`**
Expected: 0 errors.

---

### Task 6: Xây dựng State Management Providers

**Files:**
- Create: `app/lib/features/profile/state/user_data_provider.dart`
- Create: `app/lib/features/study/state/study_provider.dart`
- Create: `app/lib/features/traffic_signs/state/traffic_signs_provider.dart`
- Create: `app/lib/features/exam/state/exam_provider.dart`
- Create: `app/test/features/exam/exam_provider_test.dart`

**Interfaces:**
- Produces:
  - `UserDataProvider`: Quản lý bookmarks, câu sai, cài đặt.
  - `StudyProvider`: Quản lý ngân hàng câu hỏi, tiến độ 5 chương.
  - `TrafficSignsProvider`: Quản lý danh mục biển báo, tìm kiếm & filter theo nhóm.
  - `ExamProvider`: Quản lý đề thi 25 câu, timer 19p, chọn đáp án, nộp bài, tính ĐẠT/TRƯỢT theo luật điểm liệt.

- [ ] **Step 1: Viết Unit Test cho `ExamProvider`**
Kiểm tra:
  - Khởi tạo đề thi gồm 25 câu.
  - Đếm ngược thời gian.
  - Tính điểm: 24/25 nhưng sai câu điểm liệt -> TRƯỢT (`isPassed = false`, `isCriticalFailed = true`).
  - 21/25 không sai điểm liệt -> ĐẠT (`isPassed = true`).
- [ ] **Step 2: Cài đặt `UserDataProvider`, `StudyProvider`, `TrafficSignsProvider`**
- [ ] **Step 3: Cài đặt `ExamProvider`**
- [ ] **Step 4: Chạy test `ExamProvider`**
Run: `flutter test test/features/exam/exam_provider_test.dart`
Expected: PASS.

---

### Task 7: Xây dựng Shell Điều Hướng 4 Tab & Màn hình chính

**Files:**
- Create: `app/lib/navigation/main_navigation_screen.dart`
- Create: `app/lib/features/home/presentation/home_screen.dart`
- Create: `app/lib/features/home/presentation/widgets/exam_cta_card.dart`
- Create: `app/lib/features/home/presentation/widgets/quick_access_grid.dart`
- Create: `app/lib/features/study/presentation/study_screen.dart`
- Create: `app/lib/features/traffic_signs/presentation/traffic_signs_screen.dart`
- Create: `app/lib/features/profile/presentation/profile_screen.dart`

**Interfaces:**
- Produces: `MainNavigationScreen` tích hợp 4 Tab NavigationBar chuẩn Material 3.
  - `HomeScreen`: Header, tổng quan tiến độ, Card CTA thi sát hạch, Quick access 6 mục, bài thi gần nhất.
  - `StudyScreen`: 5 chương lý thuyết và tiến độ.
  - `TrafficSignsScreen`: 5 chips nhóm biển báo, search bar, grid 2 cột.
  - `ProfileScreen`: Sổ tay câu sai, Bookmark, Lịch sử thi, Cài đặt.

- [ ] **Step 1: Cài đặt `MainNavigationScreen`**
- [ ] **Step 2: Cài đặt `HomeScreen` cùng các sub-widgets**
- [ ] **Step 3: Cài đặt `StudyScreen`**
- [ ] **Step 4: Cài đặt `TrafficSignsScreen`**
- [ ] **Step 5: Cài đặt `ProfileScreen`**
- [ ] **Step 6: Chạy `flutter analyze`**
Expected: 0 errors.

---

### Task 8: Xây dựng Luồng Thi Sát Hạch Toàn Diện (Exam Flow)

**Files:**
- Create: `app/lib/features/exam/presentation/widgets/exam_grid_sheet.dart`
- Create: `app/lib/features/exam/presentation/exam_screen.dart`
- Create: `app/lib/features/exam/presentation/exam_result_screen.dart`
- Create: `app/lib/features/exam/presentation/exam_review_screen.dart`

**Interfaces:**
- Produces:
  - `ExamScreen`: Full-screen với timer 19:00, `PageView` vuốt ngang câu hỏi, nút trước/sau, bottom sheet ma trận 25 câu, nút nộp bài với popup cảnh báo.
  - `ExamGridSheet`: Modal Bottom Sheet hiển thị ma trận 25 ô (chưa làm / đã làm / điểm liệt / bookmark).
  - `ExamResultScreen`: Banner ĐẠT/TRƯỢT to rõ, cảnh báo điểm liệt nếu trượt, thống kê điểm, danh sách câu sai, nút Thi lại/Xem lại/Về trang chủ.
  - `ExamReviewScreen`: Xem lại chi tiết từng câu trong bài thi vừa làm kèm giải thích.

- [ ] **Step 1: Cài đặt `exam_grid_sheet.dart`**
- [ ] **Step 2: Cài đặt `exam_screen.dart`**
- [ ] **Step 3: Cài đặt `exam_result_screen.dart`**
- [ ] **Step 4: Cài đặt `exam_review_screen.dart`**
- [ ] **Step 5: Chạy `flutter analyze`**
Expected: 0 errors.

---

### Task 9: Kết nối Main Entry Point & Xác minh toàn bộ ứng dụng

**Files:**
- Modify: `app/lib/main.dart`

**Interfaces:**
- Integrates all features with `MultiProvider`, `AppTheme.lightTheme`, và `MainNavigationScreen`.

- [ ] **Step 1: Cập nhật `app/lib/main.dart`**
Khởi tạo `WidgetsFlutterBinding.ensureInitialized()`, khởi tạo `LocalStorageService`, cấu hình `MultiProvider` chứa `UserDataProvider`, `StudyProvider`, `TrafficSignsProvider`, `ExamProvider`.
- [ ] **Step 2: Kiểm tra toàn bộ mã nguồn**
Run: `flutter analyze`
Expected: 0 issues found.
- [ ] **Step 3: Chạy toàn bộ test suite**
Run: `flutter test`
Expected: Toàn bộ unit tests pass.
