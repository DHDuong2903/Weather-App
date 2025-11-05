import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app/utils/WeatherAnimation.dart';
import 'package:weather_app/components/TemperatureLineChart.dart';
import 'package:weather_app/components/WeatherDataSelector.dart';
import 'package:weather_app/components/RainForecastSection.dart';
import 'package:weather_app/utils/translations.dart';
import 'package:weather_app/services/WeatherService.dart';

class DailyForecastDetailPage extends StatefulWidget {
  final String city;
  final String date;
  final String language;
  final List<dynamic> hourlyData;

  const DailyForecastDetailPage({
    super.key,
    required this.city,
    required this.date,
    required this.language,
    required this.hourlyData,
  });

  @override
  State<DailyForecastDetailPage> createState() =>
      _DailyForecastDetailPageState();
}

class _DailyForecastDetailPageState extends State<DailyForecastDetailPage> {
  final WeatherService weatherService = WeatherService();
  List<dynamic> hourlyData = [];
  late DateTime selectedDate;
  bool _isLoading = true;

  // Mặc định hiển thị biểu đồ nhiệt độ
  String selectedDataType = "temperature";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN', null);
    selectedDate = DateTime.parse(widget.date);
    fetchHourlyData();
  }

  Future<void> fetchHourlyData() async {
    setState(() => _isLoading = true);
    try {
      hourlyData = await weatherService.getHourlyData(
        widget.city,
        widget.language,
        selectedDate,
      );
    } catch (e) {
      print("Lỗi khi tải dữ liệu giờ: $e");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ sáng/tối
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Màu nền tùy chế độ
    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF6F7F9);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final containerColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.grey.shade100;
    final accentColor = Colors.blueAccent;

    // Giới hạn 5 ngày
    final next5Days = List.generate(
      6,
      (i) => DateTime.now().add(Duration(days: i)),
    );
    final locale = widget.language == 'vi' ? 'vi_VN' : 'en_US';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          selectedDataType == "wind"
              ? AppLocalizations.get('windForecast', widget.language)
              : AppLocalizations.get('weatherCondition', widget.language),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // Thanh chọn ngày
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(next5Days.length, (index) {
                DateTime day = next5Days[index];
                bool isSelected =
                    DateFormat('yyyy-MM-dd').format(day) ==
                    DateFormat('yyyy-MM-dd').format(selectedDate);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = day;
                    });
                    fetchHourlyData();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor : containerColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? accentColor : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat.E(locale).format(day),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDarkMode
                                      ? Colors.white70
                                      : Colors.grey.shade700),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${day.day}",
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDarkMode
                                      ? Colors.white
                                      : Colors.grey.shade900),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            DateFormat(
              'EEEE, dd MMMM yyyy',
              widget.language == 'vi' ? 'vi_VN' : 'en_US',
            ).format(selectedDate),
            style: TextStyle(color: subTextColor),
          ),
          const SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: isDarkMode ? Colors.white24 : Colors.grey,
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : hourlyData.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.get('noData', widget.language),
                      style: TextStyle(color: subTextColor),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon + nhiệt độ + selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Lottie.asset(
                                    getWeatherAnimation(
                                      hourlyData[0]["weather"][0]["icon"],
                                      hourlyData[0]["weather"][0]["description"],
                                    ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${hourlyData[0]["main"]["temp"].round()}°C",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              WeatherDataSelector(
                                selectedValue: selectedDataType,
                                onSelect: (value) {
                                  setState(() {
                                    selectedDataType = value;
                                  });
                                },
                                lang: widget.language,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Biểu đồ
                          if (selectedDataType == "temperature") ...[
                            TemperatureLineChart(hourlyData: hourlyData),
                            const SizedBox(height: 20),
                            Divider(
                              thickness: 1,
                              color: isDarkMode ? Colors.white24 : Colors.grey,
                            ),
                            RainForecastSection(
                              hourlyData: hourlyData,
                              lang: widget.language,
                            ),
                          ] else if (selectedDataType == "wind") ...[
                            WindLineChart(
                              hourlyData: hourlyData,
                              lang: widget.language,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
