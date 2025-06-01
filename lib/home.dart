import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health/pages/heart.dart';
import 'package:health/pages/oxygen.dart';
import 'package:health/pages/step.dart';
import 'package:health/pages/stress.dart';
import 'package:health/bar/drawer.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double boxSize = 125; //chỉnh cho tất cả box
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(

          actions: [

            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();}, // Mở drawer
            ),

          ]
      ),

      // box chosen
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            //put text at the top of page
            padding: const EdgeInsets.all(20.0), //tạo khoảng cách các bên
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Health Care!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => oxygen()),
                  ); // on tap
                },
                child: Container(
                  height: boxSize,
                  width: boxSize,
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.bloodtype, size: 40),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SPO2",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Check your oxygen level",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          // Block 2 - Heart rate
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => heart()),
                  ); // on tap
                },
                child: Container(
                  height: boxSize,
                  width: boxSize,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.favorite, size: 40, color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Heart Rate",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Measure your heart beat",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          // Block 3 - Steps
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => steps()),
                  ); // on tap
                },
                child: Container(
                  height: boxSize,
                  width: boxSize,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.directions_walk,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Steps",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Count your daily steps",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          // Block 4 - Stress
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => stress()),
                  ); // on tap
                },
                child: Container(
                  height: boxSize,
                  width: boxSize,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.monitor_heart,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stress",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Watching your stress level",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
