import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:health/home.dart';
import 'package:health/pages/login_page.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // ✅ Nếu có user => vào HomePage
          if (snapshot.hasData) {
            return HomePage();
          }
          // ❌ Nếu chưa login => vào LoginPage
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

