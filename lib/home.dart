import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
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
    );
  }
}
