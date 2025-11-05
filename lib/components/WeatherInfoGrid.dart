import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherInfoGrid extends StatelessWidget {
  final Map<String, dynamic> data;
  final String language;

  const WeatherInfoGrid({
    super.key,
    required this.data,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final humidity = data['main']?['humidity'] ?? 0;
    final wind = data['wind']?['speed'] ?? 0;
    final rain = data['rain']?['1h'] ?? 0;
    final clouds = data['clouds']?['all'] ?? 0;
    final tempMax = data['main']?['temp_max'] ?? 0;
    final tempMin = data['main']?['temp_min'] ?? 0;

    final List<_WeatherInfoItem> items = [
      _WeatherInfoItem(
        animation: 'assets/animations/humidity.json',
        value: "$humidity%",
      ),
      _WeatherInfoItem(
        animation: 'assets/animations/Wind_gust.json',
        value: "${wind.toStringAsFixed(1)} m/s",
      ),
      _WeatherInfoItem(
        animation: 'assets/animations/Rainy.json',
        value: "${rain.toStringAsFixed(1)} mm",
      ),
      _WeatherInfoItem(
        animation: 'assets/animations/Clouds.json',
        value: "$clouds%",
      ),
      _WeatherInfoItem(
        animation: 'assets/animations/Hot_Temperature.json',
        value: "${tempMax.toStringAsFixed(1)}°C",
      ),
      _WeatherInfoItem(
        animation: 'assets/animations/Cold_Temperature.json',
        value: "${tempMin.toStringAsFixed(1)}°C",
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 4.2; // 3 thẻ/lần hiển thị

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: SizedBox(
        height: 125,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 36),
          itemBuilder: (context, index) => SizedBox(
            width: itemWidth,
            child: _buildInfoCard(context, items[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, _WeatherInfoItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container chỉ bọc animation
        Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black54 : Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Lottie.asset(item.animation, fit: BoxFit.contain),
        ),

        const SizedBox(height: 8),

        // Chỉ hiển thị value (API) dưới container
        Text(
          item.value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark
                ? const Color.fromARGB(255, 255, 255, 255)
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _WeatherInfoItem {
  final String animation;
  final String value;

  _WeatherInfoItem({required this.animation, required this.value});
}
