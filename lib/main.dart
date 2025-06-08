import 'package:flutter/material.dart';
import 'package:health/home.dart';
import 'package:health/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:health/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Thêm dòng này
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // phải khởi tạo trc
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: AuthPage()
    );
  }
}


