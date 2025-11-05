import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/utils/translations.dart';
import 'package:weather_app/themes/AppColors.dart';

class RainForecastSection extends StatefulWidget {
  final List<dynamic> hourlyData;
  final String lang;

  const RainForecastSection({
    super.key,
    required this.hourlyData,
    required this.lang,
  });

  @override
  State<RainForecastSection> createState() => _RainForecastSectionState();
}

class _RainForecastSectionState extends State<RainForecastSection> {
  List<double> hourlyRainChances = [];
  List<String> hourlyLabels = [];
  double totalRain = 0;
  String summary = "Đang tải dữ liệu...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _processRainData();
  }

  void _processRainData() {
    try {
      final List<double> rainChances = [];
      final List<String> labels = [];
      double total = 0.0;

      for (var item in widget.hourlyData) {
        final timeText = item["dt_txt"] as String;
        final dateTime = DateTime.parse(timeText);
        final hour = dateTime.hour;

        double pop = (item["pop"] ?? 0.0) * 100; // xác suất mưa %
        rainChances.add(pop);
        labels.add("${hour.toString().padLeft(2, '0')}h");

        if (item["rain"] != null && item["rain"]["3h"] != null) {
          total += (item["rain"]["3h"]).toDouble();
        }
      }

      final description = widget.hourlyData.first["weather"][0]["description"];

      setState(() {
        hourlyRainChances = rainChances;
        hourlyLabels = labels;
        totalRain = total;
        summary = description;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        summary = "Lỗi khi xử lý dữ liệu: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dùng AppColors cho toàn bộ
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;
    final chartTopColor = isDark
        ? AppColors.darkRainTop
        : AppColors.lightRainTop;
    final chartFillColor = isDark
        ? AppColors.darkRainFill
        : AppColors.lightRainFill;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final gridColor = isDark ? AppColors.darkGrid : AppColors.lightGrid;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final maxChance = hourlyRainChances.isNotEmpty
        ? hourlyRainChances.reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.get('maxRainChance', widget.lang)}: ${maxChance.round()}%",
            style: TextStyle(color: subTextColor),
          ),

          const SizedBox(height: 20),

          //  Biểu đồ khả năng mưa
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                minX: 0,
                maxX: (hourlyRainChances.length - 1).toDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 25,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: gridColor.withOpacity(0.8), strokeWidth: 1),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: gridColor.withOpacity(0.5),
                    strokeWidth: 0.8,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < hourlyLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              hourlyLabels[value.toInt()],
                              style: TextStyle(
                                fontSize: 12,
                                color: subTextColor,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 25,
                      getTitlesWidget: (value, _) => Text(
                        "${value.toInt()}%",
                        style: TextStyle(fontSize: 11, color: subTextColor),
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
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: chartTopColor,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          chartTopColor.withOpacity(0.25),
                          chartTopColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: const FlDotData(show: true),
                    spots: List.generate(
                      hourlyRainChances.length,
                      (i) => FlSpot(i.toDouble(), hourlyRainChances[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Tổng lượng mưa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.get('totalRain', widget.lang),
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              Text(
                "${totalRain.toStringAsFixed(1)} mm",
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Phần mô tả
          Text(
            AppLocalizations.get('summary', widget.lang),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: chartFillColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(summary, style: TextStyle(color: subTextColor)),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
