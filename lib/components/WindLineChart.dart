import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/utils/translations.dart';

class WindLineChart extends StatelessWidget {
  final List<dynamic> hourlyData;
  final String lang;

  const WindLineChart({
    super.key,
    required this.hourlyData,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Kiểm tra chế độ sáng/tối
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🔹 Màu tùy theo chế độ
    final bgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDarkMode ? Colors.white12 : Colors.grey.shade300;
    final gridColor = isDarkMode ? Colors.white10 : Colors.grey.shade300;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final subCardColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF2F2F7);
    final lineColor = isDarkMode ? Colors.cyanAccent : Colors.blueAccent;

    // Chuyển dữ liệu thành điểm FlSpot
    final List<FlSpot> spots = hourlyData.asMap().entries.map((e) {
      final wind = e.value["wind"];
      final speed = (wind?["speed"] ?? 0).toDouble();
      return FlSpot(e.key.toDouble(), speed);
    }).toList();

    // Giới hạn trục Y
    final double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    //  Lấy dữ liệu gió hiện tại
    final currentWind = hourlyData.first["wind"];
    final currentSpeedKmH = ((currentWind["speed"] ?? 0) * 3.6).toDouble();
    final int deg = (currentWind["deg"] ?? 0).toInt();

    // Xác định hướng gió
    String getDirection(int deg) {
      if (lang == 'vi') {
        if (deg >= 337.5 || deg < 22.5) return "Bắc";
        if (deg >= 22.5 && deg < 67.5) return "Đông Bắc";
        if (deg >= 67.5 && deg < 112.5) return "Đông";
        if (deg >= 112.5 && deg < 157.5) return "Đông Nam";
        if (deg >= 157.5 && deg < 202.5) return "Nam";
        if (deg >= 202.5 && deg < 247.5) return "Tây Nam";
        if (deg >= 247.5 && deg < 292.5) return "Tây";
        if (deg >= 292.5 && deg < 337.5) return "Tây Bắc";
        return "Không xác định";
      } else {
        if (deg >= 337.5 || deg < 22.5) return "North";
        if (deg >= 22.5 && deg < 67.5) return "Northeast";
        if (deg >= 67.5 && deg < 112.5) return "East";
        if (deg >= 112.5 && deg < 157.5) return "Southeast";
        if (deg >= 157.5 && deg < 202.5) return "South";
        if (deg >= 202.5 && deg < 247.5) return "Southwest";
        if (deg >= 247.5 && deg < 292.5) return "West";
        if (deg >= 292.5 && deg < 337.5) return "Northwest";
        return "Unknown";
      }
    }

    final direction = getDirection(deg);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Tiêu đề
          Text(
            AppLocalizations.get("wind", lang),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // 🔹 Biểu đồ đường tốc độ gió
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: minY.floorToDouble(),
                maxY: maxY.ceilToDouble(),
                backgroundColor: bgColor,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: gridColor, strokeWidth: 0.6),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= hourlyData.length) return Container();
                        final time = hourlyData[index]["dt_txt"].substring(
                          11,
                          16,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            time,
                            style: TextStyle(fontSize: 10, color: textColor),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    spots: spots,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          lineColor.withOpacity(0.35),
                          lineColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Tiêu đề phần tóm tắt
          Text(
            AppLocalizations.get("dailySummary", lang),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // 🔹 Khung tóm tắt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: subCardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              AppLocalizations.get("wind_summary", lang)
                  .replaceAll("{speed}", currentSpeedKmH.toStringAsFixed(1))
                  .replaceAll("{direction}", direction),
              style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
