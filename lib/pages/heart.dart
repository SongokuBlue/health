import 'dart:math';

import 'package:flutter/material.dart';

import 'package:health/charts/line.dart';
import 'package:health/bar/drawer.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class heart extends StatefulWidget {
  const heart({super.key});

  @override
  _HeartPageState createState() => _HeartPageState();
}
class _HeartPageState extends State<heart> {
  DateTime _lastUpdated = DateTime.now(); // Lưu trữ thời gian cập nhật
  int heart_value =1;
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
            Text("heart", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.favorite, color: Colors.red), // Icon trái tim
            SizedBox(width: 8), // Khoảng cách giữa icon và text
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              // Cập nhật lại các giá trị cần làm mới
              _lastUpdated = DateTime.now(); // Cập nhật lại thời gian
              heart_value =Random().nextInt(41) + 60; // Cập nhật lại nhịp tim giả lập
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
                  Text("$heart_value bpm",
                  style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),

                  Text("Date : 15/10/2025",
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
            const line(),
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
                    "A calm heart is a healthy heart.\nRemember to breathe and take breaks.",
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          shape: StadiumBorder(),
          elevation: 2,
        ),
      ),
    );
  }
}
