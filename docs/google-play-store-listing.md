# 🚀 Cẩm Nang & Hồ Sơ Đăng Ứng Dụng Lên Google Play (CH Play)

Tài liệu này tổng hợp **toàn bộ những gì bạn cần chuẩn bị ngoài file `.aab`**, bao gồm: văn bản mô tả chuẩn ASO, hình ảnh Store Listing, đường link chính sách, hướng dẫn điền các biểu mẫu bắt buộc và quy trình vượt qua vòng kiểm thử 20 testers.

---

## 📌 PHẦN 1: Thông Tin Trang Thông Tin Cửa Hàng (Store Listing)

### 1. Tên ứng dụng (App name) - *Tối đa 30 ký tự*
```text
GPLX A1 - 200 Câu
```

### 2. Mô tả ngắn (Short description) - *Tối đa 80 ký tự*
```text
Ôn thi lý thuyết bằng lái xe máy A1 chuẩn 200 câu Cục Đường bộ VN. Học offline.
```

### 3. Mô tả chi tiết (Full description) - *Tối đa 4000 ký tự (Copy toàn bộ đoạn dưới)*
```text
TUYÊN BỐ MIỄN TRỪ TRÁCH NHIỆM & NGUỒN DỮ LIỆU CHÍNH PHỦ:
1. Ứng dụng "GPLX A1 - 200 Câu" là phần mềm học tập độc lập, KHÔNG PHẢI LÀ ỨNG DỤNG CỦA CHÍNH PHỦ, KHÔNG ĐẠI DIỆN VÀ KHÔNG LIÊN KẾT VỚI BẤT KỲ CƠ QUAN CHÍNH PHỦ NÀO (bao gồm Bộ Giao thông Vận tải hay Cục Đường bộ Việt Nam).
2. Nguồn thông tin chính phủ (Government Information Source):
Bộ 200 câu hỏi sát hạch lý thuyết lái xe mô tô Hạng A1 và hệ thống biển báo hiệu đường bộ được tham khảo công khai từ cổng thông tin điện tử chính thức của Cục Đường bộ Việt Nam:
https://drvn.gov.vn

--------------------------------------------------
GIỚI THIỆU ỨNG DỤNG
--------------------------------------------------
GPLX A1 - 200 Câu là ứng dụng hỗ trợ ôn luyện lý thuyết sát hạch cấp giấy phép lái xe mô tô Hạng A1. Ứng dụng hoạt động 100% ngoại tuyến (offline), không cần kết nối mạng Internet, không thu thập dữ liệu cá nhân.

CÁC TÍNH NĂNG CHÍNH:
- Thi thử sát hạch: Tạo đề thi ngẫu nhiên 25 câu với thời gian đếm ngược 19 phút theo đúng cấu trúc thi thật. Tự động chấm điểm và đánh giá Đạt/Không đạt (yêu cầu đúng từ 21/25 câu và không sai câu điểm liệt).
- Ôn tập toàn bộ 200 câu hỏi: Phân loại theo 5 chương chuyên đề (khái niệm và quy tắc, văn hóa giao thông, kỹ thuật lái xe, hệ thống biển báo, giải thế sa hình) kèm giải thích chi tiết đáp án.
- Luyện riêng 20 câu điểm liệt: Tập trung ôn luyện các câu hỏi tình huống mất an toàn giao thông nghiêm trọng.
- Tra cứu biển báo đường bộ: Đầy đủ các nhóm biển báo cấm, biển hiệu lệnh, biển nguy hiểm, biển chỉ dẫn và biển phụ theo chuẩn QCVN 41:2019/BGTVT.
- Sổ tay câu sai & Đánh dấu câu khó: Tự động lưu các câu làm sai để rà soát lại và cho phép đánh dấu các câu hỏi phức tạp.
- Hướng dẫn mẹo thi: Tóm tắt mẹo nhớ nhanh câu hỏi lý thuyết và kỹ thuật thực hành sa hình (vòng số 8, đường gồ ghề, đường thăng bằng).

Ứng dụng phục vụ cộng đồng người học tự ôn luyện kiến thức lý thuyết và nâng cao hiểu biết pháp luật an toàn giao thông đường bộ.
```

---

## 🎨 PHẦN 2: Hình Ảnh Store Listing (Đã có sẵn trong dự án)

Các file ảnh đã được tạo sẵn theo đúng quy chuẩn kỹ thuật của Google Play:

1. **Biểu tượng ứng dụng (App Icon)**:
   - Kích thước: `512 x 512 px`, PNG 32-bit.
   - Vị trí file trong dự án: `app/assets/images/playstore_icon_512.png`
2. **Đồ họa quảng bá (Feature Graphic Banner)**:
   - Kích thước bắt buộc: `1024 x 500 px`, PNG/JPEG không trong suốt.
   - Vị trí file trong dự án: `app/assets/images/playstore_feature_graphic_1024x500.png`
3. **Ảnh chụp màn hình điện thoại (Phone Screenshots)**:
   - Yêu cầu: Tối thiểu 2 ảnh, tối đa 8 ảnh (tỷ lệ 16:9 hoặc 9:16, độ phân giải khuyến nghị 1080x1920 hoặc 1080x2400).
   - Bạn chỉ cần mở app trên điện thoại/máy ảo và chụp 4 màn hình tiêu biểu:
     - Màn hình 1: Trang chủ với tiến độ ôn thi và nút "Thi sát hạch"
     - Màn hình 2: Màn hình làm bài thi sát hạch (có đồng hồ đếm ngược và ma trận câu hỏi)
     - Màn hình 3: Màn hình ôn tập 20 câu điểm liệt
     - Màn hình 4: Màn hình tra cứu biển báo giao thông

---

## 🌐 PHẦN 3: Chính Sách Quyền Riêng Tư (Privacy Policy URL)

Google Play bắt buộc phải có đường dẫn công khai trước khi duyệt app:
- **File HTML đã tạo sẵn trong dự án**: `docs/privacy-policy.html`
- **Cách kích hoạt miễn phí qua GitHub Pages**:
  1. Vào repository trên GitHub: `https://github.com/huypham200104/tracnghiemlaixea1`
  2. Bấm tab **Settings** ➔ mục **Pages** (ở cột bên trái).
  3. Tại mục **Build and deployment** ➔ chọn Source: **Deploy from a branch**.
  4. Chọn Branch: **main**, thư mục: **/docs** ➔ Bấm **Save**.
  5. Sau 1 phút, đường link chính thức của bạn sẽ là:
     ```text
     https://huypham200104.github.io/tracnghiemlaixea1/privacy-policy.html
     ```
  ➔ Copy link này dán vào ô **Privacy Policy** trên Play Console.

---

## 📋 PHẦN 4: Hướng Dẫn Điền Các Biểu Mẫu Trên Play Console (App Content)

Trong mục **App content (Nội dung ứng dụng)** trên Google Play Console, bạn cần hoàn thành các mục sau:

| Biểu mẫu (Section) | Câu hỏi chính | Lựa chọn / Câu trả lời cần điền |
| :--- | :--- | :--- |
| **1. Privacy policy** | Đường link chính sách | Điền link GitHub Pages ở Phần 3 |
| **2. App access** | Ứng dụng có cần login không? | Chọn: **All functionality is available without special access** |
| **3. Ads** | Ứng dụng có quảng cáo không? | Chọn: **No, my app does not contain ads** |
| **4. Content rating (IARC)** | Khảo sát nội dung (bạo lực, chất cấm...) | Bấm trả lời khảo sát: Chọn **NO** cho tất cả các câu hỏi bạo lực/người lớn. Kết quả sẽ được xếp hạng **3+ / Everyone** |
| **5. Target audience** | Độ tuổi mục tiêu | Chọn: **18 and over** (vì thi bằng lái A1 từ 18 tuổi) |
| **6. News apps** | Có phải app tin tức không? | Chọn: **No** |
| **7. COVID-19 contact tracing** | Có theo dõi tiếp xúc COVID không? | Chọn: **My app is not a publicly available COVID-19 app** |
| **8. Data safety (An toàn dữ liệu)** | Ứng dụng có thu thập/chia sẻ dữ liệu không? | **Cực kỳ quan trọng:** Chọn **NO** (Does your app collect or share any user data? ➔ **No**). Ứng dụng 100% offline không truyền dữ liệu ra ngoài |
| **9. Government apps** | Ứng dụng có đại diện chính phủ không? | **Cực kỳ quan trọng:** Chọn **NO** (*"My app is not developed by or on behalf of a government entity"*). Nếu Google hỏi app có cung cấp thông tin/dữ liệu chính phủ không, chọn cung cấp và điền link nguồn chính thức duy nhất: `https://drvn.gov.vn` kèm xác nhận Disclaimer |

> [!IMPORTANT]
> **Cách xử lý lỗi "Missing Source Link for Government Information / Misleading Claims" từ Google Play:**
> 1. Vào **Google Play Console** ➔ chọn ứng dụng **GPLX A1 - 200 Câu**.
> 2. Vào menu cột trái: **Grow** ➔ **Store presence** ➔ **Main store listing**.
> 3. Tìm đến ô **Full description (Mô tả chi tiết)**: Xóa nội dung cũ và copy toàn bộ nội dung mới tại **Mục 3** ở trên (đã có Disclaimer và các link `.gov.vn` đặt ở cả đầu và cuối mô tả).
> 4. Nhấn **Save (Lưu)** ở góc dưới bên phải.
> 5. Vào mục **Publishing overview** (Tổng quan về việc xuất bản) ➔ Nhấn **Send changes for review** (Gửi các thay đổi để xem xét).
> *(Nếu Google yêu cầu cập nhật bản build mới, chỉ cần chạy lệnh `flutter build appbundle --release` và upload file `.aab` mới đã tích hợp sẵn màn hình Nguồn dữ liệu & Pháp lý).*

---

## 🔑 PHẦN 5: Khóa Ký Phát Hành (Upload Keystore)

Dự án đã được tạo sẵn file Keystore và cấu hình vào `android/key.properties`:
- **File Keystore**: `app/android/app/upload-keystore.jks`
- **Alias**: `upload`
- **Mật khẩu store & key**: `a1gplx2026pass`
- File `key.properties` và `*.jks` đã được bảo vệ trong `.gitignore` (không bị lộ lên Git công khai).
- Khi chạy lệnh build, Flutter sẽ tự động dùng khóa này để ký file `.aab` hợp lệ cho Google Play.

---

## 👥 PHẦN 6: Lưu Ý Về Kiểm Thử Kín (20 Testers trong 14 ngày)

Đối với **tài khoản Google Play cá nhân (Personal Account)** tạo sau tháng 11/2023, Google yêu cầu:
1. Bạn phải upload file `.aab` vào kênh **Closed testing (Kiểm thử kín)** trước.
2. Mời tối thiểu **20 người dùng (testers)** tham gia bằng cách nhập danh sách email Gmail của họ hoặc tạo nhóm Google Group.
3. 20 tester này phải cài đặt app trên điện thoại và duy trì trạng thái opt-in liên tục trong **14 ngày**.
4. Sau khi kết thúc 14 ngày, nút **Apply for production (Yêu cầu phát hành chính thức)** trên Google Play Console sẽ sáng lên để bạn gửi app cho Google duyệt lên CH Play công khai.

---

## 🛠️ PHẦN 7: Lệnh Xuất File AAB Sẵn Sàng Upload

Chỉ cần mở terminal tại thư mục `app` và chạy:
```bash
flutter build appbundle --release
```
File được xuất ra tại:
```text
app/build/app/outputs/bundle/release/app-release.aab
```
File này đã được tối ưu hóa dung lượng (thường dưới 15MB) và sẵn sàng 100% để kéo thả vào Google Play Console!
