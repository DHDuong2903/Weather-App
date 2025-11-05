import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:weather_app/utils/WeatherAnimation.dart';
import 'package:weather_app/utils/translations.dart';
import 'package:weather_app/services/WeatherService.dart';

class ForecastPage extends StatelessWidget {
  final String city;
  final String language;
  final WeatherService weatherService = WeatherService();

  ForecastPage({super.key, required this.city, required this.language});

  // Hàm lấy dữ liệu dự báo thời tiết 5 ngày
  Future<List<Map<String, dynamic>>> fetchDailyForecast() async {
    final data = await weatherService.getForecast(city, language);
    return weatherService.groupForecastByDay(data);
  }

  // Hàm lấy nhãn thứ (Th 2, Tue, v.v.)
  String getDayLabel(int index, String dateString, String lang) {
    if (index == 0) return AppLocalizations.get('today', lang);
    final date = DateTime.parse(dateString);
    final weekday = date.weekday;

    if (lang == 'vi') {
      switch (weekday) {
        case DateTime.monday:
          return "Th 2";
        case DateTime.tuesday:
          return "Th 3";
        case DateTime.wednesday:
          return "Th 4";
        case DateTime.thursday:
          return "Th 5";
        case DateTime.friday:
          return "Th 6";
        case DateTime.saturday:
          return "Th 7";
        case DateTime.sunday:
          return "CN";
      }
    } else {
      switch (weekday) {
        case DateTime.monday:
          return "Mon";
        case DateTime.tuesday:
          return "Tue";
        case DateTime.wednesday:
          return "Wed";
        case DateTime.thursday:
          return "Thu";
        case DateTime.friday:
          return "Fri";
        case DateTime.saturday:
          return "Sat";
        case DateTime.sunday:
          return "Sun";
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ sáng/tối
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF6F7F9);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey;

    final next5Days = AppLocalizations.get('next5days', language);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "$next5Days - $city",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDailyForecast(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "${AppLocalizations.get('error', language)}: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.get('noData', language),
                style: TextStyle(fontSize: 16, color: subTextColor),
              ),
            );
          }

          final forecastList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forecastList.length,
            itemBuilder: (context, index) {
              final item = forecastList[index];
              final label = getDayLabel(index, item["date"], language);
              final icon = item["icon"];
              final desc = item["desc"];
              final minT = item["min"];
              final maxT = item["max"];
              final pop = item["pop"];

              return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Ngày + icon + % mưa
                      Row(
                        children: [
                          SizedBox(
                            width: 55,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Lottie.asset(
                            getWeatherAnimation(icon, desc),
                            width: 45,
                            height: 45,
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$pop%",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Thanh nhiệt độ
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: ((maxT - minT) / 15).clamp(0.2, 1.0),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Nhiệt độ
                      Row(
                        children: [
                          Text(
                            "$minT°",
                            style: TextStyle(color: subTextColor, fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$maxT°",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
