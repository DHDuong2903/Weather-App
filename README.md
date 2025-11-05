# Đề tài

ỨNG DỤNG DỰ BÁO THỜI TIẾT

# Thành viện

 - Phạm Gia Huy - 22010043
 - Đỗ Huy Dương - 22010179

# Giới thiệu

 - Ứng dụng Dự báo thời tiết được phát triển bằng Flutter, cho phép người dùng xem thông tin thời tiết hiện tại và dự báo 5 ngày tới thông qua API của OpenWeatherMap.

 - Giao diện được thiết kế hiện đại, hỗ trợ Dark Mode, đa ngôn ngữ (Việt – Anh) và các biểu đồ trực quan thể hiện các điều kiện thời tiết theo từng khung giờ.

### Tính năng nổi bật

#### Dự báo thời tiết theo thành phố

 - Người dùng có thể lựa chọn các thành phố như Hà Nội, Tokyo, New York, London, ...

 - Tự động cập nhật dữ liệu dự báo khi thay đổi vị trí.

#### Hỗ trợ chế độ giao diện sáng / tối

 - Light mode: tông màu xanh nước biển.

 - Dark mode: tông màu đen xám hiện đại.

 - Có thể chuyển đổi nhanh bằng nút trên thanh AppBar.

#### Dự báo 5 ngày tới

 - Hiển thị nhiệt độ, lượng mưa, tốc độ gió, độ ẩm, áp suất, tầm nhìn cho từng khung giờ.

 - Dữ liệu được lấy từ OpenWeatherMap API.

#### Biểu đồ trực quan

 - Sử dụng line chart hiển thị:

     - Biểu đồ nhiệt độ theo giờ

     - Biểu đồ xác suất mưa

     - Biểu đồ tốc độ gió, độ ẩm, tầm nhìn và áp suất

 - Giúp người dùng dễ dàng theo dõi xu hướng thay đổi thời tiết.

#### Animation sinh động với Lottie

 - Hiển thị biểu tượng thời tiết động (nắng, mưa, gió, sương mù, tuyết...) bằng thư viện Lottie.

 - Tăng tính trực quan và sinh động cho giao diện.

#### Hỗ trợ đa ngôn ngữ

 - Giao diện có thể chuyển đổi giữa tiếng Việt và tiếng Anh thông qua menu chọn ngôn ngữ.

### Công nghệ sử dụng

#### Ngôn ngữ & Framework

 - Flutter (Dart) — Dùng để xây dựng toàn bộ giao diện và logic ứng dụng đa nền tảng (Android, iOS, Web).

 - Dart — Ngôn ngữ lập trình chính, tối ưu cho phát triển ứng dụng Flutter.

#### API & Dữ liệu

 - OpenWeatherMap API — Cung cấp dữ liệu thời tiết thời gian thực, bao gồm:

    - Nhiệt độ, độ ẩm, lượng mưa, tốc độ gió

    - Dự báo thời tiết 5 ngày tới (forecast)

    - Hỗ trợ đa ngôn ngữ (tiếng Việt, tiếng Anh)

#### Giao diện & Hiệu ứng

 - Lottie (package lottie) — Hiển thị animation động cho các trạng thái thời tiết (mưa, nắng, sấm, tuyết...).

 - Custom Chart (package fl_chart) — Biểu đồ dạng đường (line chart) thể hiện nhiệt độ, lượng mưa, tốc độ gió theo thời gian.

 - Dark Mode / Light Mode — Chuyển đổi giao diện linh hoạt bằng ThemeMode.

 - Custom UI — Sử dụng Container, Stack, ClipRRect, Gradient để thiết kế giao diện bo tròn, có chiều sâu.


#### Thư viện & Gói hỗ trợ

 - http — Gọi API thời tiết và xử lý JSON.

 - intl — Định dạng ngày giờ và ngôn ngữ.

 - lottie — Hiển thị hoạt ảnh thời tiết động.

 - fl_chart — Vẽ biểu đồ dự báo (nhiệt độ, mưa, gió...).

