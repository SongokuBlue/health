import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double boxSize = 125;//chỉnh cho tất cả box
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Health Care"
       , style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          height: 20,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/left-arrow.svg',
            fit: BoxFit.contain,
            // tuỳ chọn đổi màu icon nếu SVG chưa gán màu:
            colorFilter: const ColorFilter.mode(
              Colors.white60,
              BlendMode.srcIn,
            ),
          ),
        ),

      ),
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center ,
        children: [
          Row(
            children: [
              Container(
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
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SPO2", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Check your oxygen level", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          // Block 2 - Heart rate
          Row(
            children: [
              Container(
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
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Heart Rate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Measure your heart beat", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
          SizedBox(height: 20),

          // Block 3 - Steps
          Row(
            children: [
              Container(
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
                child: Icon(Icons.directions_walk, size: 40, color: Colors.white),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Steps", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Count your daily steps", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
          SizedBox(height: 20),

          // Block 4 - Stress
          Row(
            children: [
              Container(
                height: boxSize,
                width: boxSize,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.monitor_heart, size: 40, color: Colors.white),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Monitor your stress level", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
