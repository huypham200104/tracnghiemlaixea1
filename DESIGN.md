---
name: a1_design_system
description: Design system & UI guidelines cho ứng dụng Trắc Nghiệm Lái Xe A1 — Material 3, Clean Education style, chỉ Light Mode
---

# Design System — Trắc Nghiệm Lái Xe A1

Tài liệu này là **source of truth** cho toàn bộ giao diện ứng dụng.
Phong cách: **Clean Education** — Material 3, nền sáng, thẻ trắng bo góc, màu ngữ nghĩa giao thông.

> **Chế độ hiện tại:** Chỉ Light Mode (v1). Dark Mode sẽ bổ sung sau.

---

## 1. Bảng màu (Color Tokens)

### 1.1 Màu ngữ nghĩa chính

| Token | Hex | Container Hex | Ứng dụng |
|---|---|---|---|
| **Primary** (Xanh dương) | `#1565C0` | `#E3F2FD` | Nút chính, tab active, viền thẻ đã chọn, icon chính, thương hiệu |
| **Success** (Xanh lá) | `#2E7D32` | `#E8F5E9` | Đáp án đúng, badge ĐẠT, tiến độ tốt, trạng thái tích cực |
| **Error** (Đỏ) | `#C62828` | `#FFEBEE` | Đáp án sai, badge TRƯỢT, cảnh báo câu điểm liệt, trạng thái lỗi |
| **Warning** (Cam) | `#EF6C00` | `#FFF3E0` | Câu chưa trả lời, mẹo thi, bookmark, cảnh báo nhẹ, timer ≤ 5 phút |

### 1.2 Màu nền & bề mặt

| Token | Hex | Ứng dụng |
|---|---|---|
| **Canvas** | `#F6F7FB` | Nền chính toàn app |
| **Surface / Card** | `#FFFFFF` | Nền thẻ, bottom sheet, dialog |
| **Border** | `#D8DCE5` | Viền thẻ mặc định, divider |

### 1.3 Màu chữ

| Token | Hex | Ứng dụng |
|---|---|---|
| **Text Primary** | `#1B1B1F` | Tiêu đề, nội dung câu hỏi, label chính |
| **Text Secondary** | `#525866` | Mô tả phụ, metadata, ghi chú |
| **Text On Primary** | `#FFFFFF` | Chữ trên nền Primary / Error |

---

## 2. Typography

**Font:** Roboto (mặc định Material Design — không cần bundle thêm).

| Style | Size | Weight | Line Height | Ứng dụng |
|---|---|---|---|---|
| **Headline Large** | 28sp | Bold (700) | 1.3 | Kết quả thi (ĐẠT / TRƯỢT) |
| **Headline Medium** | 24sp | Bold (700) | 1.3 | Tiêu đề màn hình chính |
| **Title Large** | 22sp | SemiBold (600) | 1.3 | Tên biển báo chi tiết |
| **Title Medium** | 18sp | SemiBold (600) | 1.4 | Tiêu đề thẻ, tên chương |
| **Body Large** | 17–18sp | Regular (400) | 1.5 | **Nội dung câu hỏi** — cỡ lớn để đọc ngoài trời |
| **Body Medium** | 15sp | Regular (400) | 1.5 | Đáp án A/B/C/D, giải thích |
| **Body Small** | 13sp | Regular (400) | 1.4 | Metadata, ngày giờ, ghi chú |
| **Label Large** | 15sp | Medium (500) | 1.2 | Nút bấm, chip, tab label |
| **Label Small** | 11sp | Medium (500) | 1.2 | Badge số, caption |

> **Cỡ chữ câu hỏi** có thể điều chỉnh qua Cài đặt: Nhỏ (15sp) / Vừa (17sp) / Lớn (19sp).

---

## 3. Icons

**Bộ icon:** Material Symbols (Outlined) — nét mảnh, hiện đại.

Các icon chính thường dùng:

| Ngữ cảnh | Icon name |
|---|---|
| Trang chủ | `home` |
| Ôn tập | `menu_book` |
| Biển báo | `traffic` |
| Của tôi | `person` |
| Thi sát hạch | `quiz` / `play_circle` |
| Câu điểm liệt | `warning` |
| Mẹo thi | `tips_and_updates` |
| Lịch sử | `history` |
| Câu sai | `cancel` |
| Đúng | `check_circle` |
| Bookmark | `bookmark` / `bookmark_border` |
| Đồng hồ | `timer` |
| Zoom | `zoom_in` |
| Cài đặt | `settings` |

---

## 4. Spacing & Layout

### 4.1 Spacing Scale (bội số 4dp)

| Token | Value | Ứng dụng |
|---|---|---|
| `xs` | 4dp | Khoảng cách icon-text inline |
| `sm` | 8dp | Padding nhỏ, gap giữa badge |
| `md` | 12dp | Padding thẻ nhỏ |
| `base` | 16dp | **Padding thẻ tiêu chuẩn**, margin ngang màn hình |
| `lg` | 20dp | Gap giữa các section |
| `xl` | 24dp | Margin lớn giữa các khối |
| `2xl` | 32dp | Top/bottom padding màn hình |

### 4.2 Grid & Responsive

| Breakpoint | Width | Cột grid biển báo | Ghi chú |
|---|---|---|---|
| Phone nhỏ | 360dp – 399dp | 2 cột | Mặc định |
| Phone lớn | 400dp – 599dp | 2 cột | Chuẩn |
| Tablet | ≥ 600dp | 4 cột | Grid rộng hơn |

---

## 5. Shapes & Elevation

| Component | Border Radius | Elevation | Ghi chú |
|---|---|---|---|
| Card thông tin | 16dp | 0 (flat) | Viền 1px `#D8DCE5`, nền trắng |
| Chip / Badge | 12dp | 0 | Nền container color |
| Nút chính (Filled) | 16dp | 0 | Chiều cao 52dp |
| Nút phụ (Outlined) | 16dp | 0 | Viền 1.5px Primary |
| Dialog | 24dp | 3 | Nền trắng, scrim mờ |
| Bottom Sheet | 24dp (top) | 2 | Drag handle ở trên |
| Icon container (squircle) | 12dp | 0 | 40×40dp, nền container color |
| Ô số câu (question grid) | 12dp | 0 | 48×48dp |

---

## 6. Component Specs

### 6.1 Thẻ đáp án (Choice Card A/B/C/D)

```
┌─────────────────────────────────┐
│ ⓐ  Nội dung đáp án A           │
└─────────────────────────────────┘
```

- **Kích thước badge:** 28dp tròn, chứa chữ A/B/C/D
- **Trạng thái mặc định:** Nền trắng, viền 1px `#D8DCE5`
- **Đã chọn (thi):** Nền `#E3F2FD`, viền 2px `#1565C0`, badge xanh dương
- **Đúng (ôn tập):** Nền `#E8F5E9`, viền 2px `#2E7D32`, icon `check_circle`
- **Sai (ôn tập):** Nền `#FFEBEE`, viền 2px `#C62828`, icon `cancel`
- **Padding:** 12dp trong, gap 12dp giữa badge và text

### 6.2 Countdown Timer Pill

- **Bình thường (> 5 phút):** Nền `#1B1B1F`, chữ trắng, bo góc 20dp
- **Cảnh báo (≤ 5 phút):** Nền `#C62828`, chữ trắng, **nhấp nháy nhẹ** (pulse animation 1s)
- **Font:** Label Large, monospace cho số

### 6.3 Badge Câu Điểm Liệt

- **Chip nhỏ:** Nền `#FFEBEE`, chữ `#C62828`, icon `warning` 14dp, bo góc 8dp
- **Text:** "Điểm liệt" hoặc "Câu điểm liệt"

### 6.4 Progress Ring

- **Track:** `#E0E0E0` (2dp stroke)
- **Fill:** Primary `#1565C0` (3dp stroke)
- **Center text:** "x/200" — Body Large, bold
- **Size:** 80dp diameter

### 6.5 Nút chính (Primary Button)

- **Chiều cao:** 52dp
- **Nền:** Primary `#1565C0`
- **Chữ:** `#FFFFFF`, Label Large
- **Bo góc:** 16dp
- **Full width** trong context chính (bottom CTA)

### 6.6 Bottom Navigation Bar

- **4 tab:** Trang chủ, Ôn tập, Biển báo, Của tôi
- **Active:** Icon filled + label, màu Primary `#1565C0`
- **Inactive:** Icon outlined, màu `#525866`
- **Style:** Material 3 NavigationBar (indicator pill)

---

## 7. Animation & Micro-interactions

| Hiệu ứng | Duration | Curve | Ứng dụng |
|---|---|---|---|
| Page transition | 300ms | `easeInOut` | Chuyển màn hình (slide hoặc fade) |
| Card tap feedback | 150ms | `easeOut` | Scale down 0.97 khi nhấn |
| Progress ring fill | 800ms | `easeOutCubic` | Vòng tròn tiến độ animate khi hiển thị |
| Timer pulse | 1000ms | `easeInOut` | Nhấp nháy khi countdown ≤ 5 phút |
| Bottom sheet slide | 250ms | `easeOut` | Bảng câu hỏi trượt lên/xuống |
| Chip/badge appear | 200ms | `easeOut` | Fade + scale in cho badge trạng thái |

> **Nguyên tắc:** Animation phục vụ UX, không gây phân tâm. Tất cả animation đều nhẹ, không lạm dụng.

---

## 8. Accessibility & Touch Targets

- **Touch target tối thiểu:** 48×48dp cho mọi element tương tác
- **Tương phản chữ:** ≥ 4.5:1 (WCAG AA) — đã đảm bảo với bảng màu trên
- **Font câu hỏi:** 17–19sp với line-height 1.5 — tối ưu đọc ngoài trời
- **Ảnh biển báo / sa hình:** Hỗ trợ pinch-to-zoom và double-tap zoom

---

## 9. Quy tắc chung cho Agent

1. **Mọi màu sắc** phải lấy từ bảng token ở mục 1. Không dùng màu hardcode ngoài bảng.
2. **Không sử dụng elevation cao** (shadow đậm). App dùng flat cards với viền nhẹ.
3. **Spacing** luôn theo bội số 4dp, ưu tiên dùng các giá trị trong bảng mục 4.1.
4. **Font size câu hỏi** mặc định 17–18sp. Không nhỏ hơn 15sp cho body text.
5. **Chip trạng thái** luôn dùng container color (nhạt) + text color (đậm) từ cùng nhóm màu.
6. **Bottom Navigation** luôn hiển thị ở 4 tab chính. Ẩn khi vào màn thi full-screen hoặc màn kết quả.
7. **Nền canvas** `#F6F7FB` — không dùng trắng thuần `#FFFFFF` làm nền chính (trắng chỉ cho card/surface).
8. **Border radius** mặc định 16dp cho card, 12dp cho chip/icon container, 24dp cho dialog/sheet.
