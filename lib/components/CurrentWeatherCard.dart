import 'package:flutter/material.dart';
import 'package:weather_app/utils/WeatherAnimation.dart' as WeatherAnimation;
import 'package:weather_app/utils/Translations.dart';
import 'package:weather_app/themes/AppColors.dart';
import 'package:lottie/lottie.dart';

class CurrentWeatherCard extends StatelessWidget {
  final double temp;
  final double feelsLike;
  final String desc;
  final String icon;
  final bool isDay;
  final String city;
  final String language;

  const CurrentWeatherCard({
    super.key,
    required this.temp,
    required this.feelsLike,
    required this.desc,
    required this.icon,
    required this.isDay,
    required this.city,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final capitalizedDesc = desc.isNotEmpty
        ? desc[0].toUpperCase() + desc.substring(1)
        : desc;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    //  Nếu dark mode → màu nền đen, còn không thì gradient sáng
    final BoxDecoration boxDecoration = isDark
        ? BoxDecoration(
            color: Colors.black, // nền đen thuần
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          )
        : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lightGradientStart,
                AppColors.lightGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          );

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        decoration: boxDecoration,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            //  Phần chữ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bên trái
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      capitalizedDesc,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isDay
                          ? AppLocalizations.get('day', language)
                          : AppLocalizations.get('night', language),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDay
                            ? Colors.orangeAccent
                            : Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
                // Bên phải
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${temp.toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${AppLocalizations.get('feelsLike', language)}: ${feelsLike.toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //  Animation thời tiết
            Positioned(
              top: -120,
              left: -50,
              child: Lottie.asset(
                WeatherAnimation.getWeatherAnimation(icon, desc.toLowerCase()),
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
