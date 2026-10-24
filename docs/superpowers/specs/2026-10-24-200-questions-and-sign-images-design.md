# Đặc tả thiết kế: Ngân hàng 200 câu hỏi sát hạch A1 & Hệ thống hiển thị hình ảnh biển báo/sa hình

- **Ngày tạo:** 2026-10-24
- **Dự án:** [tracnghiemlaixea1](file:///c:/Workplace/GitHub/tracnghiemlaixea1)
- **Mục tiêu:** Mở rộng dữ liệu từ 25 câu mẫu lên đầy đủ **200 câu hỏi chính thức Hạng A1** theo quy chuẩn của Cục Đường bộ Việt Nam / Bộ GTVT, thiết lập hệ thống lưu trữ và hiển thị hình ảnh minh họa biển báo và thế sa hình 100% offline.

---

## 1. Bối cảnh & Mục tiêu

Ứng dụng ôn thi sát hạch mô tô Hạng A1 cần đáp ứng chính xác 100% nội dung thi sát hạch lý thuyết thực tế:
1. **Ngân hàng câu hỏi:** Đúng 200 câu hỏi chuẩn Bộ GTVT, trong đó có đúng **20 câu điểm liệt** (sai 1 câu là trượt ngay).
2. **Cấu trúc 5 chương ôn tập:**
   - Chương 1: Khái niệm và quy tắc giao thông đường bộ (83 câu: từ câu 1 đến câu 83)
   - Chương 2: Văn hóa giao thông và đạo đức người lái xe (5 câu: từ câu 84 đến câu 88)
   - Chương 3: Kỹ thuật lái xe (12 câu: từ câu 89 đến câu 100)
   - Chương 4: Hệ thống biển báo hiệu đường bộ (65 câu: từ câu 101 đến câu 165)
   - Chương 5: Giải các thế sa hình và kỹ năng xử lý tình huống (35 câu: từ câu 166 đến câu 200)
3. **Hình ảnh minh họa offline:**
   - Các câu hỏi thuộc chương Biển báo (Chương 4) và chương Sa hình (Chương 5) có hình ảnh minh họa đi kèm.
   - Toàn bộ hình ảnh được đóng gói sẵn trong thư mục `assets/images/` để hiển thị tức thì không cần kết nối internet.

---

## 2. Kiến trúc Dữ liệu & Lưu trữ Assets

### 2.1 Cấu trúc thư mục Assets
```
app/
├── assets/
│   ├── data/
│   │   ├── questions_a1.json      # Trọn bộ 200 câu hỏi A1 (đầy đủ 5 chương, 20 câu điểm liệt)
│   │   └── traffic_signs.json     # Danh mục biển báo giao thông chuẩn QCVN 41:2019
│   └── images/
│       ├── signs/                 # Ảnh biển báo giao thông chuẩn (P.101, W.201, R.301, I.401...)
│       └── diagrams/              # Ảnh minh họa thế sa hình ngã tư, vòng xuyến, đường ray...
```

### 2.2 Cấu hình `app/pubspec.yaml`
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/data/
    - assets/images/signs/
    - assets/images/diagrams/
```

### 2.3 Schema câu hỏi ([Question](file:///c:/Workplace/GitHub/tracnghiemlaixea1/app/lib/features/study/domain/question_model.dart))
```json
{
  "id": 101,
  "topicId": 4,
  "content": "Biển nào dưới đây báo hiệu 'Cấm xe mô tô hai bánh đi vào'?",
  "options": [
    "Biển 1.",
    "Biển 2.",
    "Biển 3."
  ],
  "correctIndex": 0,
  "isCritical": false,
  "image": "assets/images/signs/bien_cam_moto.png",
  "explanation": "Biển 1 là biển P.104 'Cấm xe mô tô' báo hiệu cấm xe mô tô các loại đi vào."
}
```

---

## 3. Cập nhật Giao diện Hiển thị Hình ảnh

### 3.1 Nâng cấp `QuestionCard` ([question_card.dart](file:///c:/Workplace/GitHub/tracnghiemlaixea1/app/lib/core/widgets/question_card.dart))
- Khi `question.image != null`:
  - Hiển thị khung ảnh bo góc 12dp, căn giữa, tỷ lệ phù hợp (max height 200dp), có viền nhẹ `AppColors.border`.
  - Có nút/chức năng chạm vào ảnh để phóng to xem chi tiết (đặc biệt quan trọng với các câu thế sa hình và biển báo chi tiết) theo đúng tiêu chuẩn [DESIGN.md](file:///c:/Workplace/GitHub/tracnghiemlaixea1/DESIGN.md).
  - Có fallback/placeholder đồ họa trực quan nếu ảnh đang tải hoặc bị thiếu.

### 3.2 Nâng cấp `TrafficSignsScreen` & `TrafficSignDetailDialog`
- Hiển thị hình ảnh minh họa biển báo rõ nét thay vì chỉ hiển thị text mã biển.
- Trong dialog chi tiết: Hiển thị ảnh biển báo kích thước lớn, sắc nét.

---

## 4. Kế hoạch kiểm thử & Nghiệm thu
1. `QuestionRepository` nạp thành công đủ 200 câu hỏi từ [questions_a1.json](file:///c:/Workplace/GitHub/tracnghiemlaixea1/app/assets/data/questions_a1.json).
2. Kiểm tra bộ lọc câu điểm liệt: Đúng chính xác **20 câu điểm liệt** theo danh mục chuẩn Bộ GTVT.
3. Kiểm tra phân bổ 5 chương ôn tập:
   - Chương 1: 83 câu
   - Chương 2: 5 câu
   - Chương 3: 12 câu
   - Chương 4: 65 câu
   - Chương 5: 35 câu
4. `flutter analyze` đạt 0 issues.
5. Toàn bộ test suite `flutter test` pass 100%.
