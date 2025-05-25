import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class line extends StatelessWidget {
  const line({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: 350,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 10,
          minY: 0,
          maxY: 200,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            verticalInterval: 1,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.red.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.red.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
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
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true,
              interval: 1,
              reservedSize: 30),
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
          lineBarsData: [],
        ),
      ),
    );
  }
}
