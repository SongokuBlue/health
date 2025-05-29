import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health/bar/textfield.dart';
import '';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController =
      TextEditingController(); // lấy giá trị string dc nhập từ user
  final passwordController = TextEditingController();

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
                label: 'Username',
                obscureText: false,
                controller: usernameController,
              ), //username
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                controller: passwordController,
              ), //password
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //log in button
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Log in",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
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
