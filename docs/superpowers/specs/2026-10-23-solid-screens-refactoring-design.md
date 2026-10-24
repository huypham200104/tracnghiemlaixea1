# Đặc tả thiết kế: Áp dụng nguyên tắc SOLID cho hệ thống Screen — Trắc Nghiệm Lái Xe A1

- **Ngày tạo:** 2026-10-23
- **Dự án:** [tracnghiemlaixea1](file:///c:/Workplace/GitHub/tracnghiemlaixea1)
- **Mục tiêu:** Tái cấu trúc các màn hình (Screens) trong ứng dụng theo 5 nguyên tắc SOLID (SRP, OCP, LSP, ISP, DIP), giúp mã nguồn dễ bảo trì, tăng tính tái sử dụng và kiểm thử độc lập.

---

## 1. Mục tiêu & Vấn đề cần giải quyết

### Hiện trạng trước refactor:
1. **Vi phạm SRP (Single Responsibility)**:
   - Các màn hình vừa render UI, vừa chứa logic điều phối Navigation (`Navigator.push`, `popUntil`), vừa định nghĩa mã HTML/Widget của các Dialogs (`showDialog`).
   - `study_screen.dart` chứa đồng thời cả `StudyScreen` lẫn `_StudySessionScreen` (hơn 150 dòng).
   - `profile_screen.dart` chứa đồng thời `ProfileScreen`, `_QuestionListScreen`, `_showSettingsDialog`, `_confirmResetData`.
2. **Vi phạm OCP (Open/Closed)**:
   - `_StudySessionScreen` và `_QuestionListScreen` làm cùng một nhiệm vụ là hiển thị danh sách câu hỏi và chọn đáp án, nhưng bị viết lặp lại ở 2 nơi.
   - Thêm một tính năng mới (ví dụ: bộ đề thi mẫu) phải sửa trực tiếp giao diện `HomeScreen` và viết lại màn hình hiển thị câu hỏi.
3. **Vi phạm DIP & ISP**:
   - Các Screen phụ thuộc trực tiếp vào các lệnh điều hướng cục bộ và các provider lớn thay vì giao tiếp qua delegate/action handler với các interface/callback nhỏ gọn.

---

## 2. Kiến trúc áp dụng 5 nguyên tắc SOLID

### 2.1 Single Responsibility Principle (SRP)
- **Tách triệt để màn hình phụ ra file riêng**:
  - `StudySessionScreen` độc lập tại `app/lib/features/study/presentation/study_session_screen.dart`.
- **Tách toàn bộ Dialogs thành các Widget độc lập**:
  - `app/lib/features/exam/presentation/dialogs/exam_start_dialog.dart`
  - `app/lib/features/exam/presentation/dialogs/exam_exit_dialog.dart`
  - `app/lib/features/exam/presentation/dialogs/exam_submit_dialog.dart`
  - `app/lib/features/home/presentation/dialogs/tips_dialog.dart`
  - `app/lib/features/traffic_signs/presentation/dialogs/traffic_sign_detail_dialog.dart`
  - `app/lib/features/profile/presentation/dialogs/app_settings_dialog.dart`
  - `app/lib/features/profile/presentation/dialogs/reset_data_confirm_dialog.dart`
- **Tách UI Sections trên HomeScreen**:
  - `HomeHeader`: Chỉ hiển thị title, status 100% offline, subtitle.
  - `HomeProgressCard`: Chỉ hiển thị tổng quan ngân hàng câu và câu điểm liệt.

### 2.2 Open/Closed Principle (OCP)
- **Chuẩn hóa `StudySessionScreen` thành Quiz/Study Player dùng chung**:
  - Nhận:
    - `title: String`
    - `questions: List<Question>`
    - `isReviewModeImmediately: bool` (cho phép hiện giải thích ngay khi chọn đáp án, dùng cho ôn tập chương và câu điểm liệt)
    - `onAnswerSelected: void Function(int questionId, int optionIndex)?`
    - `onBookmarkToggled: void Function(int questionId)?`
  - Player có thể mở rộng chạy cho:
    1. Ôn tập theo từng chương (Chương 1..5)
    2. Luyện 20 câu điểm liệt
    3. Luyện lại danh sách câu sai từ Sổ tay
    4. Luyện các câu đã bookmark
    5. Bộ đề thi mẫu trong tương lai (mà không phải sửa một dòng code nào trong `StudySessionScreen`).

### 2.3 Liskov Substitution & Interface Segregation (LSP & ISP)
- Tách các interface / callbacks hạt nhân nhỏ gọn:
  - `QuestionCard` chỉ phụ thuộc vào `Question` và các callback kiểu `ValueChanged<int>? onSelectOption`. Không truyền cả Provider vào trong widget lá.
  - Các Dialog chỉ yêu cầu các callbacks hành động tối thiểu: `onConfirm`, `onCancel`.

### 2.4 Dependency Inversion Principle (DIP)
- **Tách Coordinators / Action Handlers**:
  - `HomeCoordinator`: Quản lý việc chuyển tab, mở `TipsDialog`, mở `ExamConfirmStartDialog` và đẩy route sang `ExamScreen`.
  - `ExamCoordinator`: Quản lý việc mở `ExamExitDialog`, mở `ExamSubmitDialog`, điều hướng sang `ExamResultScreen` và `ExamReviewScreen`.
  - Giúp `HomeScreen` và `ExamScreen` trở thành UI Components thuần túy, có thể viết widget tests đơn giản mà không cần dựng routing stack phức tạp.

---

## 3. Bản đồ cấu trúc thư mục sau khi Refactor

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── storage/
│   └── widgets/
│       ├── app_button.dart
│       ├── question_card.dart
│       ├── status_badge.dart
│       └── timer_widget.dart
└── features/
    ├── home/presentation/
    │   ├── home_screen.dart
    │   ├── home_coordinator.dart
    │   ├── dialogs/tips_dialog.dart
    │   └── widgets/
    │       ├── exam_cta_card.dart
    │       ├── home_header.dart
    │       ├── home_progress_card.dart
    │       └── quick_access_grid.dart
    ├── study/presentation/
    │   ├── study_screen.dart
    │   ├── study_session_screen.dart      # Quiz Player dùng chung (OCP/LSP)
    │   └── widgets/topic_card.dart
    ├── traffic_signs/presentation/
    │   ├── traffic_signs_screen.dart
    │   └── dialogs/traffic_sign_detail_dialog.dart
    ├── profile/presentation/
    │   ├── profile_screen.dart
    │   └── dialogs/
    │       ├── app_settings_dialog.dart
    │       └── reset_data_confirm_dialog.dart
    └── exam/presentation/
        ├── exam_screen.dart
        ├── exam_coordinator.dart
        ├── exam_result_screen.dart
        ├── exam_review_screen.dart
        ├── dialogs/
        │   ├── exam_start_dialog.dart
        │   ├── exam_exit_dialog.dart
        │   └── exam_submit_dialog.dart
        └── widgets/exam_grid_sheet.dart
```

---

## 4. Kế hoạch nghiệm thu & Tiêu chuẩn đánh giá
- Mọi file không vượt quá 150–200 dòng (tuân thủ nguyên tắc Clean UI).
- Không còn bất kỳ private screen nào được định nghĩa chung trong cùng một file với screen khác.
- `flutter analyze` báo cáo 0 error, 0 warning.
- `flutter test` đảm bảo toàn bộ 12 test hiện tại cùng các test mới bổ sung pass 100%.
