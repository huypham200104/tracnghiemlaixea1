# Bộ prompt tạo UI bằng Google Stitch — Trắc Nghiệm Lái Xe A1 (Bản rút gọn chuẩn Stitch)

> **Quy chuẩn độ dài Google Stitch:**
> - **Master Prompt (Tổng thể):** ~850 ký tự (Giới hạn tối đa khuyến nghị: ≤ 1.200 ký tự). Dán vào Stitch để thiết lập toàn bộ dự án, theme và luồng chính.
> - **Micro-Prompts (Từng màn hình):** 350 – 445 ký tự/màn. Loại bỏ từ ngữ thừa, giữ trọn vẹn tokens màu, component và bố cục Material 3 để Stitch không bị "nuốt chữ" hay bỏ sót chi tiết.

---

## Bảng Token chuẩn Material 3

| Token | Hex | Ứng dụng |
|---|---|---|
| **Primary** | `#1565C0` / Container `#E3F2FD` | Nút chính, tab chọn, viền thẻ chọn, icon chính |
| **Success** | `#2E7D32` / Container `#E8F5E9` | Badge ĐẠT, đáp án đúng |
| **Error** | `#C62828` / Container `#FFEBEE` | Badge TRƯỢT, câu điểm liệt, đáp án sai |
| **Warning** | `#EF6C00` / Container `#FFF3E0` | Đồng hồ ≤ 5p, mẹo thi, cảnh báo |
| **Canvas / Card** | `#F6F7FB` (nền canvas) / `#FFFFFF` (thẻ) | Nền màn hình & nền thẻ trắng radius 16dp |
| **Text** | `#1B1B1F` (chính) / `#525866` (phụ) | Độ tương phản cao, dễ nhìn ngoài trời |

---

## 🌟 MASTER PROMPT — Toàn bộ ứng dụng (Dán tạo khung dự án)

*(Độ dài: ~850 ký tự — vừa vặn hoàn hảo cho ô nhập Stitch)*

```
Mobile Android Material 3 app "Trắc Nghiệm Lái Xe A1" (offline motorcycle quiz), Vietnamese UI.
Palette: Primary #1565C0 (container #E3F2FD), Success #2E7D32 (#E8F5E9), Error #C62828 (#FFEBEE), Warning #EF6C00 (#FFF3E0), Canvas #F6F7FB, Card #FFFFFF, Text #1B1B1F/#525866, Border 1px #D8DCE5.
Navigation: 4-tab bar (Trang chủ, Ôn tập, Biển báo, Của tôi).
Core Features:
1. Thi sát hạch: 25 câu/19 phút đếm ngược, đạt ≥21/25, sai câu điểm liệt trượt ngay.
2. Ôn tập 5 chương (200 câu) có giải thích chi tiết đáp án.
3. 20 câu điểm liệt cảnh báo đỏ.
4. Tra cứu biển báo giao thông (5 nhóm, tìm kiếm mã/tên).
5. Sổ tay lưu câu làm sai & câu đánh dấu sao.
6. Mẹo thi lý thuyết & thực hành sa hình vòng số 8.
Components: Card radius 16dp, squircle icon container 40x40dp, choice cards A/B/C/D with circular badges, filled primary button 52dp. High contrast for outdoor readability.
```

---

## BỘ MICRO-PROMPTS TỪNG MÀN HÌNH (Dán sinh từng màn)

### Prompt 0 — Design System Tokens
*(433 ký tự)*
```
Android Material 3 UI design system for "Trắc Nghiệm Lái Xe A1".
Palette: Primary #1565C0, container #E3F2FD; Success #2E7D32, container #E8F5E9; Error #C62828, container #FFEBEE; Warning #EF6C00; Canvas #F6F7FB; Surface #FFFFFF; Text #1B1B1F; Muted #525866; Border #D8DCE5.
Shapes: Card radius 16dp, chips 12dp, button 52dp (radius 16dp), icon squircle 40x40dp.
Choices: 4 stacked cards with 28dp circle badge (A,B,C,D). Selected: 2px #1565C0 border, #E3F2FD fill.
```

---

### Prompt 1 — Trang chủ (Home)
*(429 ký tự)*
```
Mobile Android M3, Vietnamese. Home screen "Trắc Nghiệm Lái Xe A1", canvas #F6F7FB.
Top: Title "Trắc Nghiệm Lái Xe A1", sub "Hạng A1 · Bộ 200 câu", icon two_wheeler #1565C0.
Hero: Filled #1565C0 card "Thi sát hạch" (25 câu · 19 phút), play button.
Progress card: Ring #1565C0 "0/200 câu", warning bar "Điểm liệt 0/20".
2-col Grid (6 cards, squircle icons): Ôn tập, Điểm liệt (badge đỏ "20"), Biển báo, Mẹo thi, Câu sai ("12"), Lịch sử. 4-tab bottom bar.
```

---

### Prompt 2 — Danh sách 5 chương ôn tập
*(434 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Ôn tập theo chương", canvas #F6F7FB.
App bar: Back arrow, title "Ôn tập theo chương".
5 white cards (radius 16dp, border #D8DCE5): Icon menu_book #1565C0, progress bar, meta "Đã ôn 12/48 câu". Red chip "Điểm liệt" if applicable.
1. Khái niệm & Quy tắc (48 câu, 6 liệt)
2. Văn hóa & Đạo đức (5 câu, 1 liệt)
3. Kỹ thuật lái xe (14 câu, 2 liệt)
4. Biển báo (55 câu)
5. Sa hình & Tình huống (78 câu, 11 liệt).
```

---

### Prompt 3 — Danh sách câu trong chương
*(412 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Chương 1 (48 câu)", canvas #F6F7FB.
App bar: Back arrow, title "Chương 1 · Khái niệm & Quy tắc".
Filter chips: "Tất cả (48)" (active #1565C0), "Chưa làm (36)", "Câu sai (3)" (text #C62828).
List: White cards, 32dp badge "Câu 1", 2-line truncated question, red chip "Điểm liệt", status icons (check_circle #2E7D32 / cancel #C62828).
Bottom: Filled button #1565C0 "Luyện tất cả 48 câu".
```

---

### Prompt 4 — Ôn tập một câu (có giải thích)
*(426 ký tự)*
```
Mobile Android M3, Vietnamese. Question study screen, canvas #F6F7FB.
App bar: Back, "Câu 12/48", bookmark. Progress bar.
Card: Red chip "Câu điểm liệt", text 18sp: "Người lái xe không được lùi xe ở...".
4 choice cards (A, B, C, D):
- B (Wrong): #FFEBEE, border 2px #C62828, icon cancel.
- C (Correct): #E8F5E9, border 2px #2E7D32, icon check_circle.
- A, D: Default white.
Explanation box: #E3F2FD, lightbulb. Bottom: "Câu trước" & "Câu tiếp".
```

---

### Prompt 5 — Thi sát hạch (màn làm bài, 19 phút)
*(442 ký tự)*
```
Mobile Android M3, Vietnamese. Fullscreen exam mode, canvas #F6F7FB.
App bar: Close icon, title "Thi sát hạch", dark countdown pill "18:42" (red if ≤ 05:00).
Subhead: "Câu 3/25" #1565C0, red chip "Câu điểm liệt", icon grid_view "Bảng câu".
Question card: Text 18sp, 16:9 diagram placeholder.
4 choices (No correct/wrong shown!): A, C, D default white. B (Selected): #E3F2FD, border 2px #1565C0.
Bottom bar: "Câu trước", "Câu sau", red outlined "Nộp bài".
```

---

### Prompt 6 — Bottom sheet bảng 25 câu
*(396 ký tự)*
```
Mobile Android M3 bottom sheet, Vietnamese. Title "Danh sách 25 câu hỏi", sub "Đã làm 18/25", top drag handle.
5x5 grid of 25 numbered squircles (48x48dp):
- Done: #E3F2FD, border #1565C0.
- Undone: White, border #D8DCE5.
- Critical: Red corner dot #C62828.
- Bookmarked: Amber bookmark #EF6C00.
- Active (Câu 3): Border 2.5px #1565C0.
Legend row: 4 chips. Bottom: Filled button #1565C0 "Tiếp tục làm bài".
```

---

### Prompt 7 — Kết quả thi: ĐẠT
*(427 ký tự)*
```
Mobile Android M3, Vietnamese. Exam result PASSED, canvas #F6F7FB.
Hero Card (#E8F5E9 bg, border #A5D6A7, center):
- Icon check_circle 64dp #2E7D32.
- Title "ĐẠT" 32sp bold #1B5E20, score "23/25 câu đúng".
- Time "14:15", date "20/10/2026".
- Green badge "Không sai câu điểm liệt".
Wrong answers list (2 cards): Badge "Câu 8", "Bạn chọn: B (#C62828) · Đáp án đúng: C (#2E7D32)".
Bottom: Filled button #1565C0 "Thi lại đề khác", outlined "Xem lại bài".
```

---

### Prompt 8 — Kết quả thi: TRƯỢT (do câu điểm liệt)
*(441 ký tự)*
```
Mobile Android M3, Vietnamese. Exam result FAILED, canvas #F6F7FB.
Hero Card (#FFEBEE bg, border #EF9A9A, center):
- Icon cancel 64dp #C62828.
- Title "TRƯỢT" 32sp bold #B71C1C, score "23/25 câu đúng".
Alert box (#FFCDD2): Icon error #C62828, bold "Sai CÂU ĐIỂM LIỆT - trượt kỳ thi ngay lập tức".
Wrong answers list: Card 1 (Red left border 4px, "Câu 14 · ĐIỂM LIỆT", B sai, C đúng), Card 2 ("Câu 20").
Bottom: Filled #1565C0 "Thi lại", outlined "Xem lại bài".
```

---

### Prompt 9 — 20 Câu hỏi điểm liệt
*(429 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "20 Câu hỏi điểm liệt", canvas #F6F7FB.
App bar: Back arrow, title "Câu điểm liệt".
Header card (#FFEBEE, border #EF9A9A): Icon warning #C62828, title "20 câu hỏi điểm liệt", sub "Sai 1 câu là trượt", progress "Đã ôn 4/20".
List: White cards, 32dp red circle badge "1", 2-line question text, status check_circle #2E7D32 / unchecked.
Bottom: Filled red button 52dp #C62828 "Luyện 20 câu điểm liệt ngay".
```

---

### Prompt 10 — Tra cứu biển báo đường bộ
*(405 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Biển báo giao thông", canvas #F6F7FB.
Search bar: Icon search, "Tìm mã biển (P.101) hoặc tên...".
Horizontal tabs: "Cấm (42)" (active #1565C0), "Hiệu lệnh (26)", "Nguy hiểm (47)", "Chỉ dẫn (38)", "Biển phụ (10)".
2-column grid: White cards, square frame with traffic sign graphic, bold blue code "P.101", name "Đường cấm".
Bottom bar: Tab "Biển báo" active #1565C0.
```

---

### Prompt 11 — Chi tiết biển báo (zoom)
*(414 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Chi tiết biển báo", canvas #F6F7FB.
App bar: Back arrow, title "P.102", icon zoom_in #1565C0.
Graphic Card: Large centered sign P.102 (Cấm đi ngược chiều), chip "Chạm 2 lần để phóng to".
Identity: Red chip "Nhóm biển báo cấm", code "P.102", title 22sp bold "Cấm đi ngược chiều".
2 content cards: "Ý nghĩa" (text 15sp) & "Mẹo ghi nhớ" (amber card #FFF3E0, lightbulb icon).
```

---

### Prompt 12 — Sổ tay câu sai & đánh dấu
*(395 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Sổ tay ôn tập", canvas #F6F7FB.
App bar: Back arrow, title "Sổ tay cá nhân".
TabBar 2 tabs: "Câu trả lời sai" (active #1565C0, red badge "12"), "Đã đánh dấu" (amber badge "5").
List: White cards, badge "Câu 19", red chip "Điểm liệt", sub "Sai 2 lần", delete icon. Swiped card reveals red delete action.
Bottom: Filled button 52dp #1565C0 "Luyện lại 12 câu sai".
```

---

### Prompt 13 — Mẹo thi lý thuyết & sa hình
*(379 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Mẹo thi A1", canvas #F6F7FB.
Segmented: "Lý thuyết 200 câu" (active #1565C0) | "Thực hành sa hình".
Cards:
- "Nhường đường vòng xuyến" (tips_and_updates #EF6C00 in #FFF3E0).
- "5 câu điểm liệt nồng độ cồn" (warning #C62828 in #FFEBEE).
- "Mẹo đi vòng số 8 không chạm vạch" (two_wheeler #2E7D32 in #E8F5E9).
Gold banner #FFF3E0: "Nhất chớm, nhì ưu, tam đường, tứ hướng".
```

---

### Prompt 14 — Của tôi / Cài đặt
*(421 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Của tôi / Cài đặt", canvas #F6F7FB.
Header: Avatar circle #E3F2FD, "Trắc Nghiệm Lái Xe A1", "v1.0 · 100% Offline".
Stats 3 tiles: "124/200" Đã ôn · "5 lần" Thi thử · "80%" Tỷ lệ đỗ.
Grouped list:
- Học tập: Câu sai ("12"), Đã đánh dấu ("5"), Lịch sử.
- Cài đặt: Cỡ chữ (18sp), Âm thanh & Rung (switch #1565C0), Xoá tiến độ (#C62828).
Banner #E8F5E9: "100% offline, không cần internet". 4-tab bar.
```

---

### Prompt 15 — Lịch sử thi sát hạch
*(409 ký tự)*
```
Mobile Android M3, Vietnamese. Screen "Lịch sử thi", canvas #F6F7FB.
App bar: Back, title "Lịch sử thi", action delete_sweep.
Filter chips: "Tất cả (5)" (active #1565C0), "Đạt (4)", "Trượt (1)".
History items:
- Item 1: Badge xanh "ĐẠT" #2E7D32, score "23/25 câu đúng", time "15:20 · 20/10".
- Item 2: Badge đỏ "TRƯỢT" #C62828, score "22/25 câu", sub "Sai câu điểm liệt".
Bottom: Filled button #1565C0 "Thi thử ngay".
```

---

### Prompt 16 — Dialogs & Empty states
*(442 ký tự)*
```
Android Material 3 dialogs, Vietnamese, white surface, radius 24dp, dimmed scrim:
1. "Bắt đầu thi sát hạch?": Icon quiz #1565C0, body "25 câu/19 phút, đạt ≥ 21/25, không sai điểm liệt". Buttons: "Huỷ" (#525866) & filled #1565C0 "Bắt đầu".
2. "Còn câu chưa làm": Icon warning #EF6C00, body "Còn 4 câu chưa làm sẽ tính là sai". Buttons: "Làm tiếp" & red filled #C62828 "Nộp bài".
3. "Thoát bài thi?": Icon logout #C62828. Buttons: "Ở lại" & red "Thoát".
```

---

## ⚡ Hướng dẫn sử dụng trên Google Stitch

1. **Bước 1 (Khởi tạo dự án):** Sao chép toàn bộ khối `MASTER PROMPT` dán vào ô chat ban đầu của Stitch để AI thiết lập ngữ cảnh toàn diện, bảng màu và bộ component gốc.
2. **Bước 2 (Sinh từng màn hình):** Với mỗi màn hình mới hoặc khi chọn "Add Screen / Generate Screen from text", sao chép đoạn prompt tương ứng từ `Prompt 1` đến `Prompt 16`.
3. **Bước 3 (Tinh chỉnh nếu cần):** Nếu Stitch vẽ chưa đúng ý, chỉ cần gõ thêm lệnh ngắn:
   - `Exam mode: do not highlight correct/wrong answers, show only selected state in #1565C0.`
   - `Make all cards white surface with radius 16dp and subtle 1px #D8DCE5 border.`
