import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatefulWidget {
  final List<DateTime> dates;
  final List<FlSpot> spots;
  final Color chartColor;
  final double y_axis;
  final String yAxisUnit;
  final bool showGoalLine; // Thêm dòng này
  final double? goalValue; // Thêm dòng này (có thể null)
  final double yaxisintervals;

  const LineChartWidget({
    super.key,
    required this.dates,
    required this.spots,
    required this.chartColor,
    required this.y_axis,
    required this.yAxisUnit,
    required this.yaxisintervals,
    this.showGoalLine = false, // Mặc định là false
    this.goalValue, // Không bắt buộc
  });

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  bool isLoading = true; // Biến để kiểm tra trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Giả lập quá trình tải dữ liệu
  Future<void> _loadData() async {
    // Thực hiện tải dữ liệu tại đây (ví dụ: lấy dữ liệu từ API hoặc DB)
    await Future.delayed(Duration(seconds: 2)); // Giả lập thời gian tải dữ liệu
    setState(() {
      isLoading = false; // Dữ liệu đã tải xong
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 350,
      child: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading indicator
          : LineChart(
        LineChartData(
          minX: 0,
          maxX: (widget.dates.length - 1).toDouble(),
          minY: 0,
          maxY: widget.y_axis,
          extraLinesData: widget.showGoalLine && widget.goalValue != null
              ? ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: widget.goalValue!,
                color: Colors.green,
                strokeWidth: 2,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 8),
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  labelResolver: (value) => 'Goal: ${value}',
                ),
              ),
            ],
          )
              : null, // Không hiển thị goal line nếu không cần
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // bỏ grid dọc để đỡ rối
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: widget.chartColor.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= widget.dates.length) {
                    return const SizedBox.shrink();
                  }

                  // Chỉ hiện label khi ngày thay đổi hoặc là điểm đầu tiên
                  bool showLabel = false;
                  if (index == 0) {
                    showLabel = true;
                  } else {
                    DateTime prevDate = widget.dates[index - 1];
                    DateTime currDate = widget.dates[index];
                    if (currDate.day != prevDate.day ||
                        currDate.month != prevDate.month ||
                        currDate.year != prevDate.year) {
                      showLabel = true;
                    }
                  }

                  if (showLabel) {
                    final date = widget.dates[index];
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
                interval: widget.yaxisintervals, // Truy cập từ widget và chuyển sang số nguyên
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
              spots: widget.spots,
              isCurved: false,
              dotData: FlDotData(show: true),
              color: widget.chartColor,
              barWidth: 3,
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  int index = spot.x.toInt();
                  if (index < 0 || index >= widget.dates.length) {
                    return null;
                  }
                  DateTime date = widget.dates[index];
                  String dateStr = "${date.day}/${date.month}/${date.year} "
                      "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

                  return LineTooltipItem(
                    "${spot.y.toStringAsFixed(1)}  ${widget.yAxisUnit} \n$dateStr",
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
