import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/utils/translations.dart';
import 'package:weather_app/themes/AppColors.dart';

class HumidityLineChart extends StatelessWidget {
  final List<dynamic> hourlyData;
  final String lang;

  const HumidityLineChart({
    super.key,
    required this.hourlyData,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //  Màu sắc theo theme
    final bgColor = AppColors.cardBackground(context);
    final textColor = AppColors.text(context);
    final subTextColor = AppColors.subText(context);
    final borderColor = AppColors.border(context);
    final gridColor = AppColors.grid(context);
    final summaryBg = AppColors.summaryBackground(context);

    // Tạo danh sách điểm FlSpot (độ ẩm %)
    final List<FlSpot> spots = hourlyData.asMap().entries.map((e) {
      final humidity = (e.value["main"]?["humidity"] ?? 0).toDouble();
      return FlSpot(e.key.toDouble(), humidity);
    }).toList();

    //  Giới hạn trục Y
    const double minY = 0;
    const double maxY = 100;

    // Lấy độ ẩm hiện tại
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final currentData = hourlyData.firstWhere(
      (e) => (e["dt"] as int) >= now,
      orElse: () => hourlyData.first,
    );
    final double currentHumidity = (currentData["main"]["humidity"] ?? 0)
        .toDouble();

    // Tính độ ẩm trung bình trong ngày
    final double avgHumidity = hourlyData.isNotEmpty
        ? hourlyData
                  .map((e) => (e["main"]["humidity"] ?? 0).toDouble())
                  .reduce((a, b) => a + b) /
              hourlyData.length
        : 0;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Biểu đồ độ ẩm
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= hourlyData.length) return Container();
                        final time = hourlyData[index]["dt_txt"]
                            .toString()
                            .substring(11, 16);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            time,
                            style: TextStyle(fontSize: 10, color: subTextColor),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) => Text(
                        "${value.toInt()}%",
                        style: TextStyle(color: subTextColor, fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: gridColor, strokeWidth: 0.6),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 3,
                    spots: spots,
                    gradient: LinearGradient(
                      colors: isDark
                          ? [Colors.cyanAccent, Colors.lightBlueAccent]
                          : [const Color(0xFF8E24AA), const Color(0xFF2196F3)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                Colors.cyanAccent.withOpacity(0.25),
                                Colors.lightBlueAccent.withOpacity(0.05),
                              ]
                            : [
                                const Color(0xFF8E24AA).withOpacity(0.25),
                                const Color(0xFF2196F3).withOpacity(0.05),
                              ],
                      ),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tóm tắt bên trong khung
          Text(
            AppLocalizations.get("dailySummary", lang),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: summaryBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              AppLocalizations.get("humidity_summary", lang)
                  .replaceAll("{current}", currentHumidity.toStringAsFixed(0))
                  .replaceAll("{avg}", avgHumidity.toStringAsFixed(0)),
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
