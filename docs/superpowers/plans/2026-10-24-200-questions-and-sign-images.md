# Kế hoạch triển khai: Nạp trọn bộ 200 câu hỏi A1 & Hệ thống hiển thị hình ảnh biển báo/sa hình

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Nạp đủ 200 câu hỏi sát hạch lý thuyết Hạng A1 chính thức của Bộ GTVT (với đúng 20 câu điểm liệt) và thiết lập cơ chế hiển thị hình ảnh minh họa biển báo, thế sa hình offline trong ứng dụng.

**Architecture:** Mở rộng dữ liệu trong `assets/data/questions_a1.json`, khai báo assets trong `pubspec.yaml`, nâng cấp `QuestionCard` hiển thị hình ảnh kèm zoom view và cập nhật màn hình tra cứu biển báo.

**Tech Stack:** Flutter 3.8+ (Dart 3+), Provider 6.1+, Material 3.

**Spec:** [2026-10-24-200-questions-and-sign-images-design.md](file:///c:/Workplace/GitHub/tracnghiemlaixea1/docs/superpowers/specs/2026-10-24-200-questions-and-sign-images-design.md)

## Global Constraints

- Số lượng câu hỏi: Đúng **200 câu** (`id` từ 1 đến 200).
- Số câu điểm liệt: Đúng **20 câu điểm liệt** theo danh mục quy chuẩn của Cục Đường bộ Việt Nam.
- Phân bổ 5 chương: Chương 1 (83 câu), Chương 2 (5 câu), Chương 3 (12 câu), Chương 4 (65 câu), Chương 5 (35 câu).
- Toàn bộ hình ảnh lưu local trong `assets/images/`, 100% không gọi mạng.
- Git policy: Chỉ dùng read-only git command.

---

### Task 1: Cấu hình thư mục Assets hình ảnh trong `pubspec.yaml`

**Files:**
- Modify: `app/pubspec.yaml`

**Interfaces:**
- Đăng ký các đường dẫn:
  - `assets/images/signs/`
  - `assets/images/diagrams/`

- [ ] **Step 1: Cập nhật `pubspec.yaml` khai báo thêm assets ảnh**
- [ ] **Step 2: Chạy `flutter pub get` để cập nhật assets index**

---

### Task 2: Xây dựng trọn bộ 200 câu hỏi A1 chuẩn Bộ GTVT vào `questions_a1.json`

**Files:**
- Modify: `app/assets/data/questions_a1.json`

**Interfaces:**
- Produces: 200 câu hỏi đầy đủ các trường: `id` (1..200), `topicId` (1..5), `content`, `options`, `correctIndex`, `isCritical` (20 câu true), `image`, `explanation`.

- [ ] **Step 1: Chuẩn bị nội dung 200 câu hỏi sát hạch A1 chuẩn hóa**
- [ ] **Step 2: Ghi dữ liệu 200 câu hỏi vào `app/assets/data/questions_a1.json`**
- [ ] **Step 3: Kiểm tra định dạng JSON hợp lệ**

---

### Task 3: Cập nhật dữ liệu danh mục biển báo trong `traffic_signs.json`

**Files:**
- Modify: `app/assets/data/traffic_signs.json`

**Interfaces:**
- Produces: Danh mục biển báo giao thông thuộc 5 nhóm (Cấm, Hiệu lệnh, Nguy hiểm, Chỉ dẫn, Phụ) kèm mô tả chuẩn và đường dẫn ảnh.

- [ ] **Step 1: Cập nhật `traffic_signs.json` đầy đủ các biển báo phổ biến của A1**

---

### Task 4: Nâng cấp `QuestionCard` hỗ trợ hiển thị ảnh và chạm phóng to (Zoom Dialog)

**Files:**
- Modify: `app/lib/core/widgets/question_card.dart`
- Create: `app/lib/core/widgets/image_zoom_dialog.dart`

**Interfaces:**
- Produces:
  - `ImageZoomDialog`: Hộp thoại xem ảnh phóng to toàn màn hình với InteractiveViewer (pinch-to-zoom).
  - `QuestionCard`: Nếu `question.image != null`, hiển thị ảnh bo góc 12dp, căn giữa, có nút chạm để phóng to và fallback thông minh nếu file ảnh đang được hoàn thiện.

- [ ] **Step 1: Tạo `image_zoom_dialog.dart`**
- [ ] **Step 2: Cập nhật `question_card.dart` tích hợp hiển thị ảnh và nút zoom**
- [ ] **Step 3: Chạy `flutter analyze`**

---

### Task 5: Nâng cấp `TrafficSignsScreen` & `TrafficSignDetailDialog` hiển thị đồ họa biển báo

**Files:**
- Create: `app/lib/core/widgets/traffic_sign_avatar.dart`
- Modify: `app/lib/features/traffic_signs/presentation/traffic_signs_screen.dart`
- Modify: `app/lib/features/traffic_signs/presentation/dialogs/traffic_sign_detail_dialog.dart`

**Interfaces:**
- Produces:
  - `TrafficSignAvatar`: Widget hiển thị biểu tượng hình học trực quan chuẩn màu sắc giao thông cho từng nhóm biển (Cấm: tròn đỏ; Hiệu lệnh: tròn xanh; Nguy hiểm: tam giác vàng viền đỏ; Chỉ dẫn: vuông/chữ nhật xanh).
  - Tích hợp vào lưới biển báo và modal chi tiết.

- [ ] **Step 1: Tạo `traffic_sign_avatar.dart`**
- [ ] **Step 2: Cập nhật `traffic_signs_screen.dart`**
- [ ] **Step 3: Cập nhật `traffic_sign_detail_dialog.dart`**
- [ ] **Step 4: Chạy `flutter analyze`**

---

### Task 6: Bổ sung Unit Test kiểm tra tính toàn vẹn của ngân hàng 200 câu hỏi

**Files:**
- Modify: `app/test/features/study/question_repository_test.dart`

**Interfaces:**
- Kiểm tra:
  - Tổng số câu hỏi đúng bằng 200 câu.
  - Số câu điểm liệt đúng bằng 20 câu.
  - Phân bổ 5 chương đúng số lượng (83, 5, 12, 65, 35).
  - Không có câu hỏi nào bị thiếu đáp án hoặc `correctIndex` vượt quá độ dài `options`.

- [ ] **Step 1: Viết test kiểm tra 200 câu hỏi trong `question_repository_test.dart`**
- [ ] **Step 2: Chạy `flutter test test/features/study/question_repository_test.dart`**

---

### Task 7: Kiểm thử toàn bộ hệ thống (`flutter analyze` & `flutter test`)

- [ ] **Step 1: Chạy `flutter analyze`**
Expected: 0 issues found.
- [ ] **Step 2: Chạy `flutter test` toàn bộ suite**
Expected: Toàn bộ tests pass 100%.
