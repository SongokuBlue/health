import 'package:flutter/material.dart';
import 'package:health/home.dart';
import 'package:health/pages/login_page.dart';
import 'package:flutter/services.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // phải khởi tạo trc
  // Cấm xoay ngang, chỉ cho phép xoay dọc
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp()); // Chạy app sau khi đã thiết lập
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}


