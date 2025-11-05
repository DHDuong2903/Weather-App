import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TemperatureLineChart extends StatelessWidget {
  final List<dynamic> hourlyData;

  const TemperatureLineChart({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          width: 1.2,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: hourlyData
                .map((e) => e["main"]["temp"] as double)
                .reduce((a, b) => a < b ? a : b)
                .floorToDouble(),
            maxY: hourlyData
                .map((e) => e["main"]["temp"] as double)
                .reduce((a, b) => a > b ? a : b)
                .ceilToDouble(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= hourlyData.length) return Container();
                    final time = hourlyData[index]["dt_txt"].substring(11, 16);
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "$time",
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : Colors.grey.shade300,
                strokeWidth: 0.6,
              ),
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: isDark ? Colors.amberAccent : Colors.orange,
                barWidth: 3,
                spots: [
                  for (int i = 0; i < hourlyData.length; i++)
                    FlSpot(
                      i.toDouble(),
                      hourlyData[i]["main"]["temp"].toDouble(),
                    ),
                ],
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            Colors.amberAccent.withOpacity(0.2),
                            Colors.amberAccent.withOpacity(0.05),
                          ]
                        : [
                            Colors.orange.withOpacity(0.25),
                            Colors.orange.withOpacity(0.05),
                          ],
                  ),
                ),
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
