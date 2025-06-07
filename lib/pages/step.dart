import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:health/charts/line.dart';
import 'package:health/bar/drawer.dart';
import 'package:health/services/firebase_data.dart';
import 'package:percent_indicator/percent_indicator.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class steps extends StatelessWidget {
  const steps({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(0xFFFDF4FF); // Màu nền app
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Căn giữa icon và text
          children: [
            Text("Step", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.directions_walk, color: Colors.blueAccent), // Icon trái tim
            SizedBox(width: 8), // Khoảng cách giữa icon và text
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              // setState(() {
              //   _loadData(); // Tải lại dữ liệu từ Firebase khi nhấn refresh
              //   _lastUpdated = DateTime.now(); // Cập nhật lại thời gian
              // });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer(); // Mở drawer
            },
          ),
        ],
      ),
      body:Align(
        alignment: Alignment.topCenter,
        child: CircularPercentIndicator(
          radius: 130,
          lineWidth: 10,
          progressColor: Colors.blue,
          percent: 0.8,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // '$steps' //sẽ dùng sau khi thiết lập database ở đây
                '7850',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Text(
                'Steps',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                '150 steps left',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
