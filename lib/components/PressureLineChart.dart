import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/utils/translations.dart';
import 'package:weather_app/themes/AppColors.dart';

class PressureLineChart extends StatelessWidget {
  final List<dynamic> hourlyData;
  final String lang;

  const PressureLineChart({
    super.key,
    required this.hourlyData,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Màu sắc tùy theo theme
    final bgColor = AppColors.cardBackground(context);
    final textColor = AppColors.text(context);
    final subTextColor = AppColors.subText(context);
    final borderColor = AppColors.border(context);
    final gridColor = AppColors.grid(context);

    // Tạo danh sách điểm dữ liệu từ áp suất (hPa)
    final List<FlSpot> spots = hourlyData.asMap().entries.map((e) {
      final pressure = (e.value["main"]?["pressure"] ?? 0).toDouble();
      return FlSpot(e.key.toDouble(), pressure);
    }).toList();

    // Lấy dữ liệu hiện tại (áp suất gần nhất)
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final currentData = hourlyData.firstWhere(
      (e) => (e["dt"] as int) >= now,
      orElse: () => hourlyData.first,
    );
    final currentPressure = (currentData["main"]["pressure"] ?? 0).toDouble();

    // Tính toán thống kê
    final pressures = hourlyData
        .map((e) => (e["main"]["pressure"] ?? 0).toDouble())
        .toList();
    final avgPressure = pressures.reduce((a, b) => a + b) / pressures.length;
    final minPressure = pressures.reduce((a, b) => a < b ? a : b);
    final maxPressure = pressures.reduce((a, b) => a > b ? a : b);

    // Mô tả áp suất tùy theo giá trị và ngôn ngữ
    String getPressureDescription(double p) {
      if (lang == 'vi') {
        if (p < 1000) return "Áp suất thấp — có thể trời sắp mưa.";
        if (p <= 1020) return "Áp suất ổn định — thời tiết bình thường.";
        return "Áp suất cao — trời có thể khô ráo, ít mây.";
      } else {
        if (p < 1000) return "Low pressure — possible rain coming.";
        if (p <= 1020) return "Stable pressure — normal weather.";
        return "High pressure — likely dry and clear skies.";
      }
    }

    final description = getPressureDescription(currentPressure);

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
          // Biểu đồ đường áp suất
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: minPressure.floorToDouble() - 2,
                maxY: maxPressure.ceilToDouble() + 2,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= hourlyData.length) return Container();
                        final time = hourlyData[index]["dt_txt"]
                            ?.toString()
                            .substring(11, 16);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            time ?? '',
                            style: TextStyle(fontSize: 10, color: subTextColor),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10, color: subTextColor),
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
                  horizontalInterval: 5,
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
                          ? [Colors.tealAccent.shade200, Colors.cyanAccent]
                          : [const Color(0xFFAB47BC), const Color(0xFF7E57C2)],
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
                                Colors.tealAccent.withOpacity(0.25),
                                Colors.cyanAccent.withOpacity(0.05),
                              ]
                            : [
                                const Color(0xFFAB47BC).withOpacity(0.25),
                                const Color(0xFF7E57C2).withOpacity(0.05),
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

          // Tiêu đề tóm tắt
          Text(
            AppLocalizations.get("dailySummary", lang),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),

          const SizedBox(height: 8),

          // Ghi chú bên trong khung
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              AppLocalizations.get("pressure_summary", lang)
                      .replaceAll("{avg}", avgPressure.toStringAsFixed(1))
                      .replaceAll("{min}", minPressure.toStringAsFixed(1))
                      .replaceAll("{max}", maxPressure.toStringAsFixed(1)) +
                  "\n$description",
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
