import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<DateTime> dates;
  final List<FlSpot> spots;
  final Color chartColor;

  const LineChartWidget({
    super.key,
    required this.dates,
    required this.spots,
    required this.chartColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 350,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (dates.length - 1).toDouble(),
          minY: 0,
          maxY: 200,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true, // bỏ grid dọc để đỡ rối
            verticalInterval: 5,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: chartColor.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= dates.length) {
                    return const SizedBox.shrink();
                  }

                  // Chỉ hiện label khi ngày thay đổi hoặc là điểm đầu tiên
                  bool showLabel = false;
                  if (index == 0) {
                    showLabel = true;
                  } else {
                    DateTime prevDate = dates[index - 1];
                    DateTime currDate = dates[index];
                    if (currDate.day != prevDate.day ||
                        currDate.month != prevDate.month ||
                        currDate.year != prevDate.year) {
                      showLabel = true;
                    }
                  }

                  if (showLabel) {
                    final date = dates[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('${date.day}/${date.month}',
                          style: const TextStyle(fontSize: 10)),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(),
              bottom: BorderSide(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: FlDotData(show: true),
              color: chartColor,
              barWidth: 3,
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  int index = spot.x.toInt();
                  if (index < 0 || index >= dates.length) {
                    return null;
                  }
                  DateTime date = dates[index];
                  String dateStr = "${date.day}/${date.month}/${date.year} "
                      "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

                  return LineTooltipItem(
                    "${spot.y.toStringAsFixed(1)} bpm\n$dateStr",
                    const TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
