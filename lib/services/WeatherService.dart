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
}
