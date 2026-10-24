# Đặc tả thiết kế kiến trúc: Hệ thống màn hình & Lưu trữ dữ liệu Offline — Trắc Nghiệm Lái Xe A1

- **Ngày tạo:** 2026-10-23
- **Dự án:** [tracnghiemlaixea1](file:///c:/Workplace/GitHub/tracnghiemlaixea1)
- **Mục tiêu:** Xây dựng hệ thống màn hình chuẩn Material 3 và cơ chế lưu trữ dữ liệu 100% offline cho ứng dụng Flutter ôn thi lý thuyết sát hạch lái xe máy Hạng A1.

---

## 1. Bối cảnh & Mục tiêu

Ứng dụng ôn thi giấy phép lái xe máy Hạng A1 hoạt động **100% offline** (zero-network), tuân thủ bộ quy tắc sát hạch của Cục Đường bộ Việt Nam / Bộ GTVT.

### Mục tiêu chính:
1. Xây dựng khung điều hướng chính (Navigation Shell) 4 Tab theo chuẩn Material 3:
   - **Trang chủ** (`HomeScreen`)
   - **Ôn tập theo chương** (`StudyScreen`)
   - **Biển báo đường bộ** (`TrafficSignsScreen`)
   - **Của tôi** (`ProfileScreen`)
2. Xây dựng trọn vẹn luồng thi sát hạch cốt lõi:
   - **Màn làm bài thi 25 câu / 19 phút** (`ExamScreen`)
   - **Màn kết quả thi ĐẠT / TRƯỢT** (`ExamResultScreen`)
   - **Màn xem lại chi tiết bài làm** (`ExamReviewScreen`)
3. Kiến trúc lưu trữ nội bộ (Local Storage):
   - Ngân hàng câu hỏi & biển báo đóng gói trong `assets/data/`.
   - Tiến độ học, câu sai, bookmark, cài đặt và lịch sử thi lưu trữ bền vững trên thiết bị thông qua `shared_preferences` và `path_provider`.

---

## 2. Kiến trúc & Công nghệ

### 2.1 Tech Stack
- **Framework:** Flutter 3.8+ (Dart 3+ strict typing, sound null safety, zero `dynamic`).
- **State Management:** `provider` (`ChangeNotifierProvider`, `MultiProvider`).
- **Local Persistence:** `shared_preferences` (cài đặt, bookmark, tiến độ) + local JSON file I/O qua `path_provider` (lịch sử các bài thi).
- **Design System:** Material 3, Clean Education style, tuân thủ [DESIGN.md](file:///c:/Workplace/GitHub/tracnghiemlaixea1/DESIGN.md).

### 2.2 Cấu trúc thư mục (Feature-first Clean Architecture)
```
app/
├── assets/
│   └── data/
│       ├── questions_a1.json          # Starter question bank (~25-30 câu chuẩn Bộ GTVT)
│       └── traffic_signs.json         # Danh mục biển báo theo 5 nhóm
└── lib/
    ├── core/
    │   ├── constants/
    │   │   ├── app_constants.dart     # 25 câu, 19 phút, 21 điểm đạt, 20 câu điểm liệt
    │   │   └── app_assets.dart        # Đường dẫn assets JSON / images
    │   ├── theme/
    │   │   ├── app_colors.dart        # Primary, Success, Error, Warning, Canvas, Card
    │   │   ├── app_typography.dart    # Roboto typography scale
    │   │   └── app_theme.dart         # Material 3 ThemeData (Light mode)
    │   ├── storage/
    │   │   └── local_storage_service.dart # Đọc/ghi SharedPreferences & Documents JSON
    │   └── widgets/
    │       ├── app_button.dart        # Nút chính/phụ chuẩn M3
    │       ├── question_card.dart     # Thẻ hiển thị câu hỏi và đáp án A/B/C/D
    │       ├── status_badge.dart      # Badge ĐẠT / TRƯỢT / Điểm liệt
    │       └── timer_widget.dart      # Đồng hồ đếm ngược 19 phút
    ├── features/
    │   ├── exam/
    │   │   ├── domain/
    │   │   │   ├── exam_model.dart    # Exam, ExamQuestion, ExamAnswer, ExamResult
    │   │   │   └── exam_repository.dart
    │   │   ├── state/
    │   │   │   └── exam_provider.dart # Quản lý bài thi, timer, chọn đáp án, nộp bài, tính kết quả
    │   │   └── presentation/
    │   │       ├── exam_screen.dart   # Màn làm bài thi (PageView + Bottom Sheet 25 câu)
    │   │       ├── exam_result_screen.dart # Màn tổng kết ĐẠT/TRƯỢT & thống kê
    │   │       ├── exam_review_screen.dart # Màn xem lại từng câu bài làm
    │   │       └── widgets/
    │   │           └── exam_grid_sheet.dart # Bảng ma trận 25 ô câu hỏi
    │   ├── home/
    │   │   └── presentation/
    │   │       ├── home_screen.dart   # Trang chủ (Header, Progress card, CTA thi, Menu grid)
    │   │       └── widgets/
    │   │           ├── exam_cta_card.dart
    │   │           └── quick_access_grid.dart
    │   ├── study/
    │   │   ├── domain/
    │   │   │   └── topic_model.dart   # Model 5 chương
    │   │   ├── state/
    │   │   │   └── study_provider.dart
    │   │   └── presentation/
    │   │       └── study_screen.dart  # Danh sách 5 chương & tiến độ
    │   ├── traffic_signs/
    │   │   ├── domain/
    │   │   │   └── traffic_sign_model.dart
    │   │   ├── state/
    │   │   │   └── traffic_signs_provider.dart
    │   │   └── presentation/
    │   │       ├── traffic_signs_screen.dart # Danh sách biển báo có tìm kiếm & filter chips
    │   │       └── widgets/
    │   │           └── traffic_sign_detail_dialog.dart
    │   └── profile/
    │       ├── state/
    │       │   └── user_data_provider.dart   # Quản lý câu sai, bookmark, cài đặt
    │       └── presentation/
    │           └── profile_screen.dart       # Sổ tay câu sai, Bookmark, Lịch sử thi, Cài đặt
    ├── navigation/
    │   └── main_navigation_screen.dart       # NavigationBar 4 Tabs
    └── main.dart                             # Entry point, MultiProvider, Theme setup
```

---

## 3. Đặc tả dữ liệu & Cơ chế lưu trữ Offline

### 3.1 Dữ liệu tĩnh (Read-only Assets)
- `assets/data/questions_a1.json`:
  ```json
  [
    {
      "id": 1,
      "topicId": 1,
      "content": "Phần của đường bộ được sử dụng cho các phương tiện giao thông qua lại là gì?",
      "options": [
        "Phần mặt đường và lề đường.",
        "Phần đường xe chạy.",
        "Phần đường xe cơ giới."
      ],
      "correctIndex": 1,
      "isCritical": false,
      "image": null,
      "explanation": "Phần đường xe chạy là phần của đường bộ được sử dụng cho các phương tiện giao thông qua lại."
    }
  ]
  ```
- `assets/data/traffic_signs.json`:
  ```json
  [
    {
      "code": "P.101",
      "name": "Đường cấm",
      "group": "cam",
      "image": null,
      "description": "Báo đường cấm tất cả các loại phương tiện đi lại cả hai hướng, trừ các xe được ưu tiên theo quy định."
    }
  ]
  ```

### 3.2 Dữ liệu người dùng (User Dynamic Data)
- **SharedPreferences**:
  - `bookmarked_question_ids`: `List<String>`
  - `wrong_question_ids`: `List<String>`
  - `topic_progress`: `Map<String, int>` (số câu đã làm theo từng chương)
  - `app_settings_font_size`: `'small' | 'medium' | 'large'`
  - `app_settings_sound_enabled`: `bool`
- **File JSON nội bộ (`path_provider` Documents Directory)**:
  - `exam_history.json`: Lưu danh sách các bài thi đã làm (`ExamResult` gồm id, timestamp, score, isPassed, isCriticalFailed, durationSeconds, answers list).

---

## 4. Đặc tả giao diện chi tiết

### 4.1 Shell điều hướng 4 Tab (`MainNavigationScreen`)
- Dùng Material 3 `NavigationBar` với `NavigationDestination`:
  1. **Trang chủ**: Icon `Icons.home_outlined` / `Icons.home`
  2. **Ôn tập**: Icon `Icons.menu_book_outlined` / `Icons.menu_book`
  3. **Biển báo**: Icon `Icons.traffic_outlined` / `Icons.traffic`
  4. **Của tôi**: Icon `Icons.person_outline` / `Icons.person`

### 4.2 Tab 1: Trang chủ (`HomeScreen`)
- **Header**: Tên app "Trắc Nghiệm Lái Xe A1" + Subtitle "Hạng A1 · Bộ 200 câu · 100% Offline".
- **Thẻ tổng quan tiến độ**:
  - Đã ôn: `x/200` câu (Progress indicator xanh lá/xanh dương).
  - Điểm liệt đã ôn: `y/20` câu (Badge cảnh báo đỏ).
- **Hero CTA Card: "Thi sát hạch"**:
  - Nút lớn, nổi bật màu Primary (`#1565C0`).
  - Thông số: 25 câu · 19 phút · Đạt ≥ 21/25.
  - Nhấn nút: Hiển thị Dialog xác nhận nhanh ("Đề thi 25 câu trong 19 phút. Sai 1 câu điểm liệt sẽ trượt ngay.") -> Bắt đầu làm bài.
- **Quick Access Grid (2 cột)**:
  - Ôn tập 5 chương (`Icons.school`)
  - 20 Câu điểm liệt (`Icons.warning_amber_rounded`, viền đỏ nhẹ)
  - Biển báo giao thông (`Icons.alt_route`)
  - Mẹo thi A1 (`Icons.lightbulb_outline`)
  - Sổ tay câu sai (`Icons.cancel_outlined`, kèm badge số lượng câu sai)
  - Lịch sử bài thi (`Icons.history`)
- **Khối lần thi gần nhất**: Hiển thị thẻ kết quả của bài thi gần nhất (ĐẠT / TRƯỢT, điểm số, ngày thi).

### 4.3 Tab 2: Ôn tập theo chương (`StudyScreen`)
- Thẻ cho từng chương trong số 5 chương:
  1. Khái niệm và quy tắc giao thông đường bộ
  2. Văn hóa giao thông và đạo đức người lái xe
  3. Kỹ thuật lái xe
  4. Hệ thống biển báo hiệu đường bộ
  5. Giải các thế sa hình và kỹ năng xử lý tình huống
- Mỗi thẻ gồm: Tên chương, thanh tiến độ làm bài, số lượng câu điểm liệt có trong chương.

### 4.4 Tab 3: Biển báo đường bộ (`TrafficSignsScreen`)
- Thanh tìm kiếm theo mã (P.101, W.203...) hoặc tên biển.
- 5 chip lọc danh mục: Biển báo cấm, Biển hiệu lệnh, Biển nguy hiểm, Biển chỉ dẫn, Biển phụ.
- Grid 2 cột danh sách biển báo (Icon/ảnh, mã biển, tên ngắn).
- Chạm vào thẻ: Mở Dialog chi tiết biển báo kèm giải thích ý nghĩa.

### 4.5 Tab 4: Của tôi (`ProfileScreen`)
- Danh mục chính:
  - Sổ tay câu làm sai (số lượng câu sai, nút "Luyện lại câu sai").
  - Câu hỏi đã đánh dấu bookmark.
  - Lịch sử thi sát hạch (danh sách ngày thi, điểm số, trạng thái ĐẠT/TRƯỢT).
  - Cài đặt (cỡ chữ hiển thị, âm thanh, thông tin phiên bản).

---

## 5. Đặc tả luồng thi sát hạch (Core Exam Flow)

### 5.1 Màn làm bài thi (`ExamScreen` - Full Screen)
- **AppBar**:
  - Nút đóng (hiện dialog xác nhận "Thoát bài thi? Bài làm sẽ không được lưu").
  - Đồng hồ đếm ngược `19:00`: chuyển màu đỏ (`#C62828`) khi thời gian còn ≤ 5 phút.
  - Nút icon ma trận mở Bottom Sheet 25 câu.
- **Thanh chỉ báo câu hỏi**:
  - Hiển thị "Câu x / 25".
  - Nếu câu hiện tại là câu điểm liệt: Badge màu đỏ nổi bật `CÂU ĐIỂM LIỆT`.
  - Icon bookmark để lưu câu khó.
- **Khu vực câu hỏi (`PageView`)**:
  - Vuốt ngang mượt mà chuyển giữa các câu.
  - Nội dung câu hỏi chữ lớn, rõ nét.
  - Danh sách 4 đáp án dạng thẻ tùy chọn (A, B, C, D):
    - Trạng thái chưa chọn: Viền xám `#D8DCE5`, nền trắng.
    - Trạng thái đã chọn: Viền xanh dương đậm `#1565C0`, nền xanh dương nhạt `#E3F2FD`.
- **Thanh điều hướng dưới cùng**:
  - Nút "Câu trước" và "Câu sau".
  - Nút nổi bật "Nộp bài".
- **Bottom Sheet Ma trận 25 câu (`ExamGridSheet`)**:
  - Lưới 5x5 gồm 25 ô:
    - Xám: Chưa làm.
    - Xanh dương: Đã chọn đáp án.
    - Viền/chấm đỏ: Câu điểm liệt.
    - Icon cam: Câu đã đánh dấu bookmark.
  - Chạm vào ô bất kỳ -> Chuyển ngay đến câu hỏi đó.
- **Quy tắc nộp bài**:
  - Bấm nộp bài: Nếu còn câu chưa chọn -> Hiện Dialog cảnh báo: "Còn N câu chưa trả lời. Bạn có chắc chắn muốn nộp bài?".
  - Hết giờ (00:00) -> Tự động nộp bài và chuyển đến màn Kết quả.

### 5.2 Màn kết quả thi (`ExamResultScreen` - Full Screen)
- **Banner lớn thông báo kết quả**:
  - **ĐẠT** (Nền xanh lá `#E8F5E9`, chữ & icon xanh lá `#2E7D32`) khi `đúng ≥ 21/25` VÀ `số câu điểm liệt sai = 0`.
  - **TRƯỢT** (Nền đỏ `#FFEBEE`, chữ & icon đỏ `#C62828`) khi `đúng < 21/25` HOẶC `sai câu điểm liệt`.
- **Cảnh báo điểm liệt**: Nếu trượt do câu điểm liệt -> Hiển thị cảnh báo: *"Bạn đã trả lời sai câu điểm liệt — Bị đánh trượt bất kể tổng số điểm"*.
- **Thông số thống kê bài thi**:
  - Số câu đúng: `x/25`.
  - Thời gian hoàn thành: `mm:ss`.
  - Số câu điểm liệt làm đúng: `k/k`.
- **Danh sách câu trả lời sai**:
  - Hiển thị danh sách câu sai (nội dung câu, đáp án bạn chọn so với đáp án đúng).
- **Hành động**:
  - Nút "Thi lại đề mới"
  - Nút "Xem lại toàn bộ bài làm"
  - Nút "Về trang chủ"
- **Tự động lưu**: Lưu ngay kết quả vào lịch sử bài thi và đẩy các câu làm sai vào Sổ tay câu sai.

### 5.3 Màn xem lại bài làm (`ExamReviewScreen`)
- Xem lại đầy đủ 25 câu của bài thi vừa làm:
  - Hiển thị rõ đáp án người dùng đã chọn (đỏ nếu sai, xanh nếu đúng).
  - Đánh dấu đáp án chuẩn (xanh lá).
  - Khung giải thích chi tiết đáp án.

---

## 6. Danh mục Dependency phê duyệt (`pubspec.yaml`)
- `provider: ^6.1.2`
- `shared_preferences: ^2.5.2`
- `path_provider: ^2.1.5`

---

## 7. Kế hoạch xác minh & Tiêu chuẩn nghiệm thu
- Chạy `flutter pub get` và `flutter analyze` bảo đảm:
  - 0 compile errors.
  - 0 warning / lints.
  - Strict null-safety.
- Đảm bảo app chạy 100% không phụ thuộc internet, toàn bộ dữ liệu mẫu nạp mượt mà từ assets.
