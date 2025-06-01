import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:health/charts/line.dart';
import 'package:health/bar/drawer.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class oxygen extends StatefulWidget {
  const oxygen({super.key});

  @override
  _OxyPageState createState() => _OxyPageState();
}
class _OxyPageState extends State<oxygen> {

  DateTime _lastUpdated = DateTime.now(); // Lưu trữ thời gian cập nhật

  String selectedFilter = ""; // Mặc định
  double oxy_value =0;
  List<DateTime> filterdates = [];
  List<DateTime> dates = [
    DateTime(2025, 5, 26),
    DateTime(2025, 5, 27),
    DateTime(2025, 5, 28),
    DateTime(2025, 5, 29),
    DateTime(2025, 5, 30),
    DateTime(2025, 5, 31),
  ]; //giả định data về sau xóa nốt

  List<double> values = [75, 78, 92, 80, 100, 85];

  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    _updateSpots();
    oxy_value = values.last;
    filterdates = [...dates];
  }
  void _updateSpots() {
    spots = List.generate(
      values.length,
          (index) => FlSpot(index.toDouble(), values[index]),
    );
  }

  Widget build(BuildContext context) {

    final backgroundColor = Color(0xFFFDF4FF); // màu nền app
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Căn giữa icon và text
          children: [
            Text("Oxygen", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.favorite, color: Colors.greenAccent), // Icon trái tim
            SizedBox(width: 8), // Khoảng cách giữa icon và text
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              final now = dates.last.add(Duration(days: 1)); // Ngày tiếp theo
              final newValue = 90 + Random().nextInt(10); //2 hàng này là test thêm dữ liệu sau sẽ bỏ

              dates.add(now);
              values.add(newValue.toDouble()); //cập nhật thử list data
              // Cập nhật lại các giá trị cần làm mới
              _lastUpdated = DateTime.now(); // Cập nhật lại thời gian
              oxy_value = values[values.length-1]; // Cập nhật lại nhịp tim giả lập
              filterdates = [...dates];
              _updateSpots();
            });
          }
              ,  icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();}, // Mở drawer
          ),

        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Last Measured result",
                    style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),
                  Text("${oxy_value.toStringAsFixed(1)} %",
                    style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),

                  Text("Date : ${_formatDate(filterdates.last)}",
                    style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            // Nút chọn thời gian
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton("Days"),
                _buildFilterButton("Week"),
                _buildFilterButton("Months"),
                _buildFilterButton("Years"),
              ],
            ),
            SizedBox(height: 32),
            // Biểu đồ trực tiếp không container
            LineChartWidget(dates: filterdates, spots: spots,chartColor: Colors.greenAccent,),
            SizedBox(height: 32),
            Text("Last updated: ${_lastUpdated.toString()}"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "❤️ Health Tip",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    " When you own your breath, nobody can steal your peace.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tạo button chọn thời gian
  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        onPressed: () {
          _filterData(label);
        },
        child: Text(label),
        style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.purple : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.purple,
          shape: StadiumBorder(),
          elevation: 2,
        ),
      ),
    );
  }
  void _filterData(String filter) {
    setState(() {
      if (selectedFilter == filter) {
        // Nếu đang chọn filter đó => bấm lại lần nữa sẽ hủy chọn
        selectedFilter = ""; // hoặc "All"
        filterdates = [...dates];
        _updateSpots(); // cập nhật lại spots từ toàn bộ values
      } else {
        // Áp dụng filter mới
        selectedFilter = filter;
        DateTime now = DateTime.now();
        DateTime startDate;

        switch (filter) {
          case "Days":
            startDate = now.subtract(Duration(days: 1));
            break;
          case "Week":
            startDate = now.subtract(Duration(days: 7));
            break;
          case "Months":
            startDate = DateTime(now.year, now.month - 1, now.day);
            break;
          case "Years":
            startDate = DateTime(now.year - 1, now.month, now.day);
            break;
          default:
            startDate = DateTime(2000);
        }

        List<FlSpot> newSpots = [];
        List<DateTime> newDates = [];

        for (int i = 0; i < dates.length; i++) {
          if (dates[i].isAfter(startDate)) {
            newSpots.add(FlSpot(newDates.length.toDouble(), values[i]));
            newDates.add(dates[i]);
          }
        }

        spots = newSpots;
        filterdates = newDates;
      }
    });
  }


}
String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}

