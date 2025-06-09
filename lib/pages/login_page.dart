import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health/bar/textfield.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final EmailController = TextEditingController(); // lấy giá trị string dc nhập từ user
  final passwordController = TextEditingController();
  void signUserIn() async {
    // Mở loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // thêm dòng này
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Gọi Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: EmailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Đóng loading dialog
    } on FirebaseAuthException catch (e) {
       Navigator.pop(context); // Đóng loading dialog

      switch (e.code) {
        case 'invalid-credential':
          _showErrorDialog("Wrong email or password");
          break;
        case 'channel-error':
          _showErrorDialog("Please enter full password and email");
          break;
        case 'too-many-requests':
          _showErrorDialog("login failed many times ,please try again later ");
          break;
        default:
          _showErrorDialog("there is error please try again.");
          debugPrint("FirebaseAuth error: ${e.code}");
      }
    }
  }
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error login"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context,).viewInsets.bottom, // tránh bị che bởi bàn phím
          ),
          child: Column(
            children: [
              //icon
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/heart.svg',
                  width: 250,
                  height: 250,
                ),
              ),
              const SizedBox(height: 30),
              //login and password field
              CustomTextField(
                label: 'Email',
                obscureText: false,
                controller: EmailController,
              ), //username
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                controller: passwordController,
              ), //password
              const SizedBox(height: 10),


              //log in button
              ElevatedButton(
                onPressed: signUserIn, // gọi hàm khi bấm
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  "Log in",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't you have an account?"),
                  const SizedBox(width: 10),
                  Text(
                    "Create an account",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
