# Kế hoạch triển khai: Tái cấu trúc Screen theo nguyên tắc SOLID — Trắc Nghiệm Lái Xe A1

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Tái cấu trúc toàn bộ hệ thống màn hình và presentation layer theo 5 nguyên tắc SOLID (SRP, OCP, LSP, ISP, DIP), giúp các screen gọn nhẹ, độc lập và dễ mở rộng.

**Architecture:** Bóc tách sub-screens lồng nhau, tách dialogs thành widget độc lập, tách Coordinator/Action Handler điều phối navigation và chuẩn hóa `StudySessionScreen` thành Quiz/Study Player dùng chung.

**Tech Stack:** Flutter 3.8+ (Dart 3+ strict), Provider 6.1+, Material 3.

**Spec:** [2026-10-23-solid-screens-refactoring-design.md](file:///c:/Workplace/GitHub/tracnghiemlaixea1/docs/superpowers/specs/2026-10-23-solid-screens-refactoring-design.md)

## Global Constraints

- Không làm thay đổi nghiệp vụ: 25 câu, 19 phút, đạt ≥ 21, sai điểm liệt là trượt ngay lập tức.
- Giữ nguyên các Design Tokens Material 3 và bảng màu ngữ nghĩa giao thông.
- 0 lỗi phân tích tĩnh (`flutter analyze`), 100% tests hiện tại và mới phải PASS.
- Git policy: Chỉ dùng read-only git command.

---

### Task 1: Tách các Dialog độc lập cho Exam & Home (SRP)

**Files:**
- Create: `app/lib/features/home/presentation/dialogs/tips_dialog.dart`
- Create: `app/lib/features/exam/presentation/dialogs/exam_start_dialog.dart`
- Create: `app/lib/features/exam/presentation/dialogs/exam_exit_dialog.dart`
- Create: `app/lib/features/exam/presentation/dialogs/exam_submit_dialog.dart`

**Interfaces:**
- Produces:
  - `TipsDialog`: Dialog hiển thị mẹo thi 4 phần (điểm liệt, xe ưu tiên, hướng ưu tiên, vòng số 8).
  - `ExamStartDialog`: Dialog xác nhận 25 câu, 19 phút, cảnh báo điểm liệt.
  - `ExamExitDialog`: Dialog cảnh báo bài làm không được lưu khi thoát.
  - `ExamSubmitDialog`: Dialog thông báo số câu chưa làm trước khi nộp.

- [ ] **Step 1: Tạo `tips_dialog.dart`**
- [ ] **Step 2: Tạo `exam_start_dialog.dart`**
- [ ] **Step 3: Tạo `exam_exit_dialog.dart`**
- [ ] **Step 4: Tạo `exam_submit_dialog.dart`**
- [ ] **Step 5: Chạy `flutter analyze` kiểm tra cú pháp**

---

### Task 2: Tách các Dialog độc lập cho Biển báo & Profile (SRP)

**Files:**
- Create: `app/lib/features/traffic_signs/presentation/dialogs/traffic_sign_detail_dialog.dart`
- Create: `app/lib/features/profile/presentation/dialogs/app_settings_dialog.dart`
- Create: `app/lib/features/profile/presentation/dialogs/reset_data_confirm_dialog.dart`

**Interfaces:**
- Produces:
  - `TrafficSignDetailDialog`: Dialog hiển thị chi tiết mã, nhóm, ý nghĩa biển báo.
  - `AppSettingsDialog`: Dialog chọn cỡ chữ, âm thanh, nút xóa dữ liệu.
  - `ResetDataConfirmDialog`: Dialog xác nhận xóa toàn bộ dữ liệu người dùng.

- [ ] **Step 1: Tạo `traffic_sign_detail_dialog.dart`**
- [ ] **Step 2: Tạo `app_settings_dialog.dart`**
- [ ] **Step 3: Tạo `reset_data_confirm_dialog.dart`**
- [ ] **Step 4: Chạy `flutter analyze` kiểm tra cú pháp**

---

### Task 3: Tách UI Components & HomeCoordinator cho HomeScreen (SRP & DIP)

**Files:**
- Create: `app/lib/features/home/presentation/widgets/home_header.dart`
- Create: `app/lib/features/home/presentation/widgets/home_progress_card.dart`
- Create: `app/lib/features/home/presentation/home_coordinator.dart`
- Modify: `app/lib/features/home/presentation/widgets/exam_cta_card.dart`
- Modify: `app/lib/features/home/presentation/home_screen.dart`

**Interfaces:**
- Produces:
  - `HomeHeader`: Widget chỉ hiển thị tiêu đề, trạng thái offline và bộ đề.
  - `HomeProgressCard`: Widget hiển thị số câu ngân hàng và câu điểm liệt.
  - `HomeCoordinator`: Đóng gói logic mở `TipsDialog`, xác nhận vào thi và chuyển sang `ExamScreen`.
  - `HomeScreen`: Chỉ render giao diện, ủy quyền xử lý cho `HomeCoordinator`.

- [ ] **Step 1: Tạo `home_header.dart` và `home_progress_card.dart`**
- [ ] **Step 2: Tạo `home_coordinator.dart`**
- [ ] **Step 3: Cập nhật `exam_cta_card.dart` nhận callback hành động đơn giản**
- [ ] **Step 4: Tái cấu trúc `home_screen.dart` tinh gọn (dưới 120 dòng)**
- [ ] **Step 5: Chạy `flutter analyze` kiểm tra cú pháp**

---

### Task 4: Xây dựng Quiz/Study Player dùng chung & Refactor StudyScreen (OCP, LSP, SRP)

**Files:**
- Create: `app/lib/features/study/presentation/study_session_screen.dart`
- Create: `app/lib/features/study/presentation/widgets/topic_card.dart`
- Modify: `app/lib/features/study/presentation/study_screen.dart`

**Interfaces:**
- Produces:
  - `StudySessionScreen`: Màn hình Player hiển thị danh sách câu hỏi độc lập với `PageView`, nhận danh sách câu hỏi, cờ xem giải thích ngay và các callbacks. Dùng chung cho: Ôn tập chương, Điểm liệt, Sổ tay câu sai, Bookmark.
  - `TopicCard`: Thẻ hiển thị từng chương.
  - `StudyScreen`: Bỏ `_StudySessionScreen` lồng nhau, gọi `StudySessionScreen`.

- [ ] **Step 1: Tạo `study_session_screen.dart`**
- [ ] **Step 2: Tạo `topic_card.dart`**
- [ ] **Step 3: Tái cấu trúc `study_screen.dart` sử dụng `TopicCard` và `StudySessionScreen`**
- [ ] **Step 4: Chạy `flutter analyze`**

---

### Task 5: Refactor ProfileScreen & TrafficSignsScreen (SRP & OCP)

**Files:**
- Modify: `app/lib/features/traffic_signs/presentation/traffic_signs_screen.dart`
- Modify: `app/lib/features/profile/presentation/profile_screen.dart`

**Interfaces:**
- Tái sử dụng `TrafficSignDetailDialog`, `AppSettingsDialog`, `ResetDataConfirmDialog` và `StudySessionScreen`.

- [ ] **Step 1: Refactor `traffic_signs_screen.dart` sử dụng `TrafficSignDetailDialog`**
- [ ] **Step 2: Refactor `profile_screen.dart`: Bỏ `_QuestionListScreen` lồng nhau, tái sử dụng `StudySessionScreen`**
- [ ] **Step 3: Chạy `flutter analyze`**

---

### Task 6: Tách ExamCoordinator & Refactor ExamScreen + ExamResultScreen (SRP & DIP)

**Files:**
- Create: `app/lib/features/exam/presentation/exam_coordinator.dart`
- Modify: `app/lib/features/exam/presentation/exam_screen.dart`
- Modify: `app/lib/features/exam/presentation/exam_result_screen.dart`

**Interfaces:**
- Produces:
  - `ExamCoordinator`: Đóng gói logic điều phối thoát bài thi (`ExamExitDialog`), nộp bài thi (`ExamSubmitDialog`), nạp kết quả và chuyển màn hình.
  - `ExamScreen`: Tinh gọn, chỉ quản lý hiển thị `PageView`, timer và ủy quyền cho `ExamCoordinator`.
  - `ExamResultScreen`: Tinh gọn các hành động nạp đề mới và điều hướng.

- [ ] **Step 1: Tạo `exam_coordinator.dart`**
- [ ] **Step 2: Refactor `exam_screen.dart`**
- [ ] **Step 3: Refactor `exam_result_screen.dart`**
- [ ] **Step 4: Chạy `flutter analyze`**

---

### Task 7: Kiểm thử & Xác minh toàn bộ hệ thống sau Refactor

**Files:**
- Modify: `app/test/widget_test.dart` (nếu cần bổ sung test)

- [ ] **Step 1: Chạy `flutter analyze`**
Run: `flutter analyze`
Expected: 0 issues found.
- [ ] **Step 2: Chạy toàn bộ Test Suite**
Run: `flutter test`
Expected: 100% tests pass.
