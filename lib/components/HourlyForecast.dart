import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/themes/AppColors.dart';
import 'package:weather_app/utils/WeatherAnimation.dart' as WeatherAnimation;

class HourlyForecast extends StatelessWidget {
  final List<dynamic> forecastList;
  final String language;

  const HourlyForecast({
    super.key,
    required this.forecastList,
    required this.language,
  });

  bool _isCurrentHour(String forecastTime) {
    final forecastDateTime = DateTime.parse(forecastTime);
    final now = DateTime.now();
    return (forecastDateTime.difference(now).inHours).abs() <= 1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDark
        ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
        : [
            const Color.fromARGB(255, 175, 174, 255),
            const Color.fromARGB(255, 140, 88, 253),
          ];

    // 🔹 Giới hạn 8 giờ đầu tiên
    final displayedForecasts = forecastList.length > 8
        ? forecastList.take(8).toList()
        : forecastList;

    // 🔹 Chia thành nhóm 4 giờ/lần
    final pageCount = (displayedForecasts.length / 4).ceil();

    return Container(
      color: isDark
          ? AppColors
                .darkBackground //  Dark mode → nền đen
          : const Color(0xFFF6F7F9), //  Light mode → nền trắng
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 140, // 🔹 nhỏ hơn
        child: PageView.builder(
          itemCount: pageCount,
          controller: PageController(viewportFraction: 0.95),
          itemBuilder: (context, pageIndex) {
            final start = pageIndex * 4;
            final end = (start + 4).clamp(0, displayedForecasts.length);
            final group = displayedForecasts.sublist(start, end);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: group.map((forecast) {
                final timeText = forecast['dt_txt'];
                final time = DateFormat.Hm().format(DateTime.parse(timeText));
                final icon = forecast['weather'][0]['icon'];
                final desc = forecast['weather'][0]['description'];
                final temp = forecast['main']['temp'].round();
                final isNow = _isCurrentHour(timeText);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 80, // 🔹 thu nhỏ
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isNow
                        ? LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isNow
                        ? null
                        : (isDark ? Colors.black54 : Colors.white),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isNow
                          ? Colors.white.withValues(alpha: 0.6)
                          : const Color.fromARGB(
                              255,
                              207,
                              206,
                              206,
                            ).withValues(alpha: 0.25),
                      width: isNow ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isNow
                            ? Colors.blueAccent.withValues(alpha: 0.35)
                            : Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isNow
                              ? Colors.white
                              : (isDark
                                    ? Color.fromARGB(255, 255, 255, 255)
                                    : Colors.black87),
                        ),
                      ),
                      //  Animation thời tiết
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Lottie.asset(
                          WeatherAnimation.getWeatherAnimation(
                            icon,
                            desc.toLowerCase(),
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        "$temp°C",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isNow
                              ? Colors.white
                              : (isDark ? Color.fromARGB(255, 255, 255, 255) : Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
