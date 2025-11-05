import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'b3b9ca0e4f3641ad8869f583f8861098';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // lay thoi tiet hien tai
  Future<Map<String, dynamic>> getCurrentWeather(
    String city,
    String lang,
  ) async {
    final url = Uri.parse(
      '$baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=$lang',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Không thể tải dữ liệu thời tiết hiện tại");
    }
  }

  //  lay du bao thoi tiet 5 ngay
  Future<Map<String, dynamic>> getForecast(String city, String lang) async {
    final url = Uri.parse(
      '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=$lang',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Không thể tải dữ liệu dự báo 5 ngày");
    }
  }
  // Gom dữ liệu theo ngày (sử dụng lại trong ForecastPage)
  List<Map<String, dynamic>> groupForecastByDay(Map<String, dynamic> data) {
    final List<dynamic> forecastList = data['list'] ?? [];
    final Map<String, List<dynamic>> groupedByDate = {};

    for (var item in forecastList) {
      final date = item['dt_txt'].substring(0, 10);
      groupedByDate.putIfAbsent(date, () => []).add(item);
    }

    final List<Map<String, dynamic>> dailyForecasts = [];
    groupedByDate.forEach((date, entries) {
      double minTemp = entries.first["main"]["temp_min"];
      double maxTemp = entries.first["main"]["temp_max"];
      double avgPop = 0;
      String desc = entries.first["weather"][0]["description"];
      String icon = entries.first["weather"][0]["icon"];

      for (var e in entries) {
        minTemp = e["main"]["temp_min"] < minTemp
            ? e["main"]["temp_min"]
            : minTemp;
        maxTemp = e["main"]["temp_max"] > maxTemp
            ? e["main"]["temp_max"]
            : maxTemp;
        avgPop += (e["pop"] ?? 0);
      }

      avgPop = (avgPop / entries.length) * 100;

      dailyForecasts.add({
        "date": date,
        "min": minTemp.round(),
        "max": maxTemp.round(),
        "pop": avgPop.round(),
        "icon": icon,
        "desc": desc,
        "hourlyData": entries,
      });
    });

    return dailyForecasts;
  }

  // Lấy dữ liệu giờ cụ thể trong ngày
  Future<List<dynamic>> getHourlyData(
    String city,
    String lang,
    DateTime date,
  ) async {
    final forecastData = await getForecast(city, lang);
    final List<dynamic> list = forecastData['list'];

    return list.where((e) {
      final dt = DateTime.parse(e['dt_txt']).toLocal();
      return dt.day == date.day &&
          dt.month == date.month &&
          dt.year == date.year;
    }).toList();
  }
}
