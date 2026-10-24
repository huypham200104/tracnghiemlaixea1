# Đặc tả chức năng — Trắc Nghiệm Lái Xe A1 (Offline)

Ứng dụng Flutter ôn thi và thi thử lý thuyết bằng lái xe máy **Hạng A1** theo quy định của
Cục Đường bộ Việt Nam. **100% offline** — không cần internet, không tài khoản, toàn bộ dữ liệu
nằm trong app.

---

## 1. Quy tắc nghiệp vụ bất biến

| Hằng số | Giá trị | Ghi chú |
|---|---|---|
| Tổng số câu hỏi | **200** | Chuẩn bộ đề A1 |
| Số câu mỗi đề thi | **25** | Trích ngẫu nhiên từ 200 câu |
| Thời gian làm bài | **19 phút** | Đếm ngược, hết giờ tự nộp |
| Điểm đạt | **≥ 21/25** | Đúng 21 câu trở lên |
| Câu điểm liệt | **20 câu** | Sai **1 câu** ⇒ **TRƯỢT ngay** dù đúng 24/25 |
| Số chương ôn tập | **5** | Theo cấu trúc bộ đề |

**Quy tắc chấm:** `Kết quả = ĐẠT` khi và chỉ khi `số câu đúng ≥ 21` **VÀ** `số câu điểm liệt sai = 0`.
Trường hợp sai câu điểm liệt, kết quả hiển thị lý do rõ ràng: "Trượt do trả lời sai câu điểm liệt".

## 2. Phạm vi

**Có:**
- Thi thử 25 câu / 19 phút, chấm điểm tự động, xem lại bài làm.
- Ôn tập theo 5 chương, xem đáp án + giải thích ngay.
- Chuyên mục 20 câu điểm liệt.
- Tra cứu biển báo theo 5 nhóm, có tìm kiếm và zoom ảnh.
- Sổ tay câu sai + câu đã đánh dấu, luyện lại.
- Mẹo thi lý thuyết & thực hành.
- Lịch sử thi, tiến độ học, cài đặt hiển thị.

**Không có (giữ nguyên tinh thần offline):**
- Không đăng nhập, không đồng bộ cloud, không quảng cáo, không analytics mạng.
- Không làm bài thi thực hành sa hình bằng mô phỏng 3D.

## 3. Kiến trúc điều hướng

Bottom navigation 4 tab (Material 3 NavigationBar), màn thi/kết quả mở **full-screen** (ẩn bottom bar):

```
[Tab 1] Trang chủ
   ├─ Thi sát hạch            → Màn thi (full-screen) → Kết quả thi → Xem lại bài
   ├─ Ôn tập theo chương      → Tab 2
   ├─ Câu điểm liệt           → Danh sách 20 câu → Luyện điểm liệt
   ├─ Mẹo thi                 → Danh sách mẹo → Chi tiết mẹo
   ├─ Sổ tay câu sai          → Tab 4 (mục Sổ tay)
   └─ Lịch sử thi             → Danh sách lịch sử → Chi tiết bài làm

[Tab 2] Ôn tập
   └─ Danh sách 5 chương      → Danh sách câu trong chương → Màn ôn tập

[Tab 3] Biển báo
   ├─ Tabs 5 nhóm biển báo    → Chi tiết biển báo (zoom)
   └─ Ô tìm kiếm theo mã/tên

[Tab 4] Của tôi
   ├─ Câu trả lời sai (badge số lượng)
   ├─ Câu đã đánh dấu
   ├─ Lịch sử thi
   └─ Cài đặt / Thông tin app
```

## 4. Chi tiết từng chức năng

### 4.1 Trang chủ
**Mục đích:** điểm vào duy nhất, thấy ngay tiến độ và nút thi.
**Thành phần:**
- Header: tên app + dòng phụ "Hạng A1 · Bộ 200 câu · Offline".
- Thẻ tiến độ tổng: vòng tròn "Đã ôn **x/200** câu", thanh "Câu điểm liệt **y/20**".
- Nút lớn chủ đạo: **Thi sát hạch** (25 câu · 19 phút · Đạt ≥ 21/25).
- Grid 2 cột các lối vào: Ôn tập theo chương, Câu điểm liệt, Biển báo, Mẹo thi, Sổ tay câu sai, Lịch sử thi.
- Khối "Lần thi gần nhất": ĐẠT/TRƯỢT + điểm + thời gian; nếu chưa có → ẩn.

**Hành vi:** chạm thẻ → điều hướng tương ứng; nút Thi sát hạch mở hộp thoại xác nhận nhanh
("Đề gồm 25 câu, 19 phút, trả lời sai câu điểm liệt sẽ trượt ngay") → Bắt đầu.

### 4.2 Thi sát hạch
**Màn thi (full-screen):**
- AppBar: tên "Thi sát hạch", bộ đếm **19:00** đếm ngược (đổi màu đỏ và rung nhẹ khi còn ≤ 5 phút).
- Tiến độ "Câu 3/25", badge **"Câu điểm liệt"** (đỏ) nếu câu hiện tại là câu điểm liệt.
- Nội dung câu hỏi; ảnh biển báo/sa hình (nếu có) hiển thị 16:9, chạm để zoom.
- 4 đáp án dạng thẻ chọn 1 (A, B, C, D); đã chọn thì viền + nền xanh dương nhạt.
- Thanh điều hướng: `Câu trước` / `Câu sau`, nút **Nộp bài**.
- Bảng 25 ô số câu (bottom sheet hoặc panel): màu xanh dương = đã trả lời, xám = chưa, đỏ có gắn cờ = câu điểm liệt, icon bookmark cam = đã đánh dấu. Chạm ô ⇒ nhảy tới câu đó.
- Nút bookmark trên từng câu (lưu câu khó).

**Hành vi:**
- Chọn đáp án **không** hiện đúng/sai trong lúc thi.
- Nộp bài: nếu còn câu chưa trả lời → hộp thoại "Còn N câu chưa trả lời. Vẫn nộp bài?".
- Hết 19 phút → tự động nộp, hiển thị toast "Hết giờ làm bài".
- Thoát giữa chừng → hộp thoại "Thoát bài thi? Bài làm sẽ không được lưu."

### 4.3 Kết quả thi
- Khối kết quả lớn: **ĐẠT** (xanh lá `#2E7D32`) hoặc **TRƯỢT** (đỏ `#C62828`).
- Điểm: "**21/25** câu đúng" + thời gian làm "12:34".
- Nếu trượt vì câu điểm liệt: banner đỏ "Bạn trả lời sai **câu điểm liệt** — trượt bất kể điểm số".
- Danh sách câu sai (số câu + trích nội dung + đáp án bạn chọn / đáp án đúng), có badge điểm liệt.
- Hành động: **Thi lại**, **Xem lại bài làm**, **Về trang chủ**.
- Bài làm được lưu vào lịch sử thi ngay khi nộp.

### 4.4 Ôn tập theo chương (5 chương)
1. Khái niệm và quy tắc giao thông đường bộ
2. Văn hóa giao thông và đạo đức người lái xe
3. Kỹ thuật lái xe
4. Hệ thống biển báo hiệu đường bộ
5. Giải các thế sa hình và kỹ năng xử lý tình huống

**Danh sách chương:** thẻ mỗi chương gồm icon, tên chương, "đã làm x/y câu", progress bar, số câu điểm liệt trong chương.
**Danh sách câu:** số câu + trạng thái (chưa làm / đúng / sai), lọc "Tất cả / Chưa làm / Câu sai".
**Màn ôn tập (1 câu/lần):** không giới hạn thời gian; chọn đáp án ⇒ hiện ngay đúng (xanh lá) / sai (đỏ) + đáp án đúng + khung "Giải thích"; nút `Câu tiếp`, bookmark, đánh dấu đã xem.
**Hành vi:** câu sai tự động vào Sổ tay câu sai; tiến độ lưu persistent.

### 4.5 Câu điểm liệt
- Danh sách 20 câu, sắp theo số câu gốc, mỗi item có badge đỏ "Điểm liệt" + trạng thái đã ôn.
- Nút **Luyện 20 câu điểm liệt** → màn ôn tập dạng flashcard/luồng câu, có câu hỏi tổng kết "Bạn đúng 18/20 câu điểm liệt".
- Nhấn mạnh cảnh báo: sai 1 câu là trượt.

### 4.6 Biển báo đường bộ
- 4 tab + 1 nhóm: **Biển báo cấm**, **Biển hiệu lệnh**, **Biển nguy hiểm**, **Biển chỉ dẫn**, **Biển phụ** (dùng chip lọc hoặc TabBar scrollable).
- Ô tìm kiếm theo mã (P.101, W.203...) hoặc tên.
- Grid 2 cột: ảnh biển + mã + tên ngắn (tối đa 2 dòng).
- Chi tiết: ảnh lớn trên nền trắng, pinch-to-zoom + double-tap, mã biển, tên, nhóm, mô tả ý nghĩa.
- Trạng thái rỗng khi tìm không thấy: "Không tìm thấy biển báo phù hợp".

### 4.7 Sổ tay câu sai & đánh dấu
- 2 tab: **Câu trả lời sai** | **Đã đánh dấu**, kèm số lượng.
- Item: số câu, nội dung rút gọn, số lần sai, ngày sai gần nhất, nút xoá khỏi sổ tay.
- Nút nổi/CTA: **Luyện lại N câu** → màn ôn tập theo danh sách này.
- Vuốt để xoá (Swipe to dismiss) + Xoá tất cả trong menu.
- Trạng thái rỗng: minh hoạ + "Chưa có câu nào. Hãy làm bài để hệ thống ghi lại câu sai."

### 4.8 Mẹo thi
- 2 nhóm: **Mẹo lý thuyết** (nhớ biển báo, câu điểm liệt, sa hình, mẹo loại trừ) và **Mẹo thực hành** (vòng số 8, đường gồ ghề, đường hẹp vuông góc, mẹo giữ bình tĩnh).
- Danh sách thẻ có tiêu đề + mô tả ngắn.
- Chi tiết: bài viết dạng markdown, có ảnh minh hoạ, mục "Mẹo ghi nhớ nhanh" highlight màu cam.

### 4.9 Lịch sử thi
- Danh sách bài thi đã làm (mới nhất trước): ĐẠT/TRƯỢT, điểm x/25, thời gian làm, ngày giờ.
- Chạm → xem lại chi tiết bài làm (đáp án đã chọn, đáp án đúng, giải thích).
- Xoá một dòng / xoá toàn bộ lịch sử.

### 4.10 Cài đặt / Thông tin
- Giao diện: Theo hệ thống / Sáng / Tối.
- Cỡ chữ câu hỏi: Nhỏ / Vừa / Lớn (áp dụng cho màn làm bài).
- Bật/tắt âm thanh + rung khi hết giờ / có kết quả.
- Xoá tiến độ học tập (có hộp thoại xác nhận).
- Phiên bản app, "Bộ dữ liệu 200 câu — cập nhật 2026", dòng "Ứng dụng hoạt động 100% offline".

## 5. Luồng chính

**Luồng thi:** Trang chủ → Thi sát hạch → Xác nhận → Làm 25 câu (chọn đáp án, điều hướng) → Nộp bài / Hết giờ → Kết quả → Xem lại / Thi lại / Trang chủ.

**Luồng ôn tập:** Ôn tập → Chọn chương → Chọn câu → Trả lời → Xem giải thích → Câu tiếp. Câu sai được ghi vào Sổ tay.

**Luồng tra biển báo:** Biển báo → Chọn nhóm → Cuộn grid hoặc tìm kiếm → Chạm → Chi tiết (zoom).

## 6. Yêu cầu UI/UX

- **Material 3**, bo góc 12–16dp, thẻ elevation thấp (0–1dp), khoảng cách bội số của 8dp.
- **Design tokens (ngữ nghĩa giao thông):**
  - Xanh lá `#2E7D32` / `#4CAF50`: đáp án đúng, ĐẠT, tiến độ tốt.
  - Đỏ `#C62828` / `#E53935`: đáp án sai, **câu điểm liệt**, TRƯỢT, cảnh báo.
  - Cam `#EF6C00` / `#FFA000`: câu chưa trả lời, mẹo/cảnh báo nhẹ, bookmark.
  - Xanh dương `#1565C0` / `#1976D2`: màu thương hiệu, biển hiệu lệnh, câu đã trả lời, hành động chính.
- Font: Roboto / Inter; cỡ câu hỏi 17–19sp, line-height 1.5 để đọc ngoài trời.
- Responsive 360dp–430dp và tablet; grid biển báo 2 cột (điện thoại) / 4 cột (tablet).
- Touch target ≥ 48dp, tương phản ≥ 4.5:1, hỗ trợ dark mode.
- Mọi ảnh câu hỏi/biển báo: ảnh local, rõ nét, hỗ trợ zoom.

## 7. Dữ liệu local

- `assets/data/questions_a1.json` — 200 câu: `id`, `topicId`, `content`, `options[4]`, `correctIndex`, `isCritical`, `image` (nếu có), `explanation`.
- `assets/data/traffic_signs.json` — `code`, `name`, `group` (cam/hieulenh/nguyhiem/chidan/phu), `image`, `description`.
- `assets/data/exam_tips.json` — `title`, `group`, `summary`, `body`, `image`.
- SharedPreferences/DB local: `wrong_questions`, `bookmarked`, `topic_progress`, `exam_history`.

## 8. Nghiệm thu (checklist)

- [ ] Đề thi luôn 25 câu, đúng 19:00 đếm ngược, tự nộp khi hết giờ.
- [ ] Sai một câu điểm liệt ⇒ TRƯỢT, kể cả 24/25.
- [ ] 21/25 và không sai điểm liệt ⇒ ĐẠT.
- [ ] Câu sai tự vào Sổ tay; đánh dấu được giữ sau khi khởi động lại app.
- [ ] Không có bất kỳ request mạng nào; chạy được ở chế độ máy bay.
- [ ] Biển báo zoom được, tìm kiếm theo mã chính xác.
