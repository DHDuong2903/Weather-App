import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/utils/translations.dart';
import 'package:weather_app/themes/AppColors.dart';

class VisibilityLineChart extends StatelessWidget {
  final List<dynamic> hourlyData;
  final String lang;

  const VisibilityLineChart({
    super.key,
    required this.hourlyData,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tạo danh sách các điểm cho biểu đồ (đơn vị: km)
    final List<FlSpot> spots = hourlyData.asMap().entries.map((e) {
      final visibility = ((e.value["visibility"] ?? 0) / 1000)
          .toDouble(); // m → km
      return FlSpot(e.key.toDouble(), visibility);
    }).toList();

    // Lấy dữ liệu hiện tại gần nhất so với thời điểm hiện tại
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final currentData = hourlyData.firstWhere(
      (e) => (e["dt"] as int) >= now,
      orElse: () => hourlyData.first,
    );
    final currentVisibilityKm = ((currentData["visibility"] ?? 0) / 1000)
        .toDouble();

    // Mô tả ngắn gọn theo tầm nhìn
    String getVisibilityDescription(double km) {
      if (lang == 'vi') {
        if (km >= 10) return "Điều kiện nhìn xa rất tốt.";
        if (km >= 5) return "Tầm nhìn khá tốt.";
        if (km >= 2) return "Tầm nhìn trung bình.";
        return "Tầm nhìn kém, có thể có sương mù.";
      } else {
        if (km >= 10) return "Excellent visibility conditions.";
        if (km >= 5) return "Good visibility.";
        if (km >= 2) return "Moderate visibility.";
        return "Poor visibility, possible fog.";
      }
    }

    final description = getVisibilityDescription(currentVisibilityKm);

    // Màu dùng cho chế độ sáng / tối
    final bgColor = AppColors.cardBackground(context);
    final textColor = AppColors.text(context);
    final subTextColor = AppColors.subText(context);
    final borderColor = AppColors.border(context);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.6)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Biểu đồ đường
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index % 2 != 0) return const SizedBox.shrink();
                        if (index < hourlyData.length) {
                          final dt = DateTime.fromMillisecondsSinceEpoch(
                            (hourlyData[index]["dt"] ?? 0) * 1000,
                            isUtc: true,
                          ).toLocal();
                          return Text(
                            "${dt.hour.toString().padLeft(2, '0')}:00",
                            style: TextStyle(fontSize: 10, color: subTextColor),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) => Text(
                        "${value.toInt()} km",
                        style: TextStyle(fontSize: 10, color: subTextColor),
                      ),
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    strokeWidth: 0.6,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    strokeWidth: 0.6,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: borderColor),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF64B5F6), const Color(0xFF1976D2)]
                          : [const Color(0xFFB8B4C1), const Color(0xFF8E9DA9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                const Color(0xFF64B5F6).withOpacity(0.3),
                                const Color(0xFF1976D2).withOpacity(0.05),
                              ]
                            : [
                                const Color.fromARGB(
                                  255,
                                  167,
                                  164,
                                  172,
                                ).withOpacity(0.3),
                                const Color.fromARGB(
                                  255,
                                  241,
                                  242,
                                  244,
                                ).withOpacity(0.3),
                              ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tiêu đề "Tóm tắt hàng ngày"
          Text(
            AppLocalizations.get('dailySummary', lang),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),

          const SizedBox(height: 8),

          // Khung tóm tắt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade800.withOpacity(0.8)
                  : const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              AppLocalizations.get('visibility_summary', lang).replaceFirst(
                '{current}',
                '${currentVisibilityKm.toStringAsFixed(1)} km — $description',
              ),
              style: TextStyle(fontSize: 14, color: subTextColor, height: 1.4),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
