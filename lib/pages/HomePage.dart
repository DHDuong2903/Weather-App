import 'package:flutter/material.dart';
import 'package:weather_app/pages/ForecastPage.dart';
import 'package:weather_app/themes/AppColors.dart';
import 'package:weather_app/utils/Translations.dart';
import 'package:weather_app/components/CustomAppBar.dart';
import 'package:weather_app/components/CurrentWeatherCard.dart';
import 'package:weather_app/components/WeatherInfoGrid.dart';
import 'package:weather_app/components/HourlyForecast.dart';
import 'package:weather_app/services/WeatherService.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = "Hanoi";
  String language = 'vi';
  final weatherService = WeatherService();

  Future<Map<String, dynamic>> fetchWeather() async {
    return await weatherService.getCurrentWeather(city, language);
  }

  Future<Map<String, dynamic>> fetchForecast() async {
    return await weatherService.getForecast(city, language);
  }

  String getCityImage(String city) {
    switch (city.toLowerCase()) {
      case 'hanoi':
        return 'assets/images/hanoi.jpg';
      case 'new york':
        return 'assets/images/newyork.jpg';
      case 'tokyo':
        return 'assets/images/tokyo.jpg';
      case 'london':
        return 'assets/images/london.jpg';
      default:
        return 'assets/images/default_city.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        toggleTheme: widget.toggleTheme,
        city: city,
        language: language,
        onCityChanged: (val) => setState(() => city = val),
        onLanguageChanged: (val) => setState(() => language = val),
      ),
      body: FutureBuilder(
        future: Future.wait([fetchWeather(), fetchForecast()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.get('error', language)));
          } else {
            final weatherData = snapshot.data![0];
            final forecastData = snapshot.data![1];

            final temp = weatherData['main']['temp']?.toDouble() ?? 0.0;
            final feelsLike =
                weatherData['main']['feels_like']?.toDouble() ?? 0.0;
            final desc = weatherData['weather'][0]['description'] ?? '';
            final icon = weatherData['weather'][0]['icon'] ?? '01d';
            final isDay = icon.contains('d');
            final forecastList = forecastData['list'] ?? [];

            return Stack(
              children: [
                // anh nen cac dia diem
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenHeight * 0.45,
                  child: Image.asset(getCityImage(city), fit: BoxFit.cover),
                ),

                // nen bo goc phia duoi
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenHeight * 0.6,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors
                                .darkBackground // Darkmode
                          : const Color(0xFFF6F7F9), // Lightmode
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),

                // noi dung chinh
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.35),

                      // hien thi thoi tiet hien tai
                      CurrentWeatherCard(
                        temp: temp,
                        feelsLike: feelsLike,
                        desc: desc,
                        icon: icon,
                        isDay: isDay,
                        city: city,
                        language: language,
                      ),

                      // hien thi cac chi so thoi tiet khac
                      WeatherInfoGrid(data: weatherData, language: language),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.get('today', language),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          )
                                        : null,
                                  ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.calendar_today, size: 18),
                              label: Text(
                                AppLocalizations.get('next5days', language),
                                style: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForecastPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // hien thi du bao thoi tiet trong ngay theo gio
                      HourlyForecast(
                        forecastList: forecastList,
                        language: language,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
