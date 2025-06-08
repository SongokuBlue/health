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
  void signUserIn()async{
    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(),);
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: EmailController.text,
          password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    Navigator.pop(context);
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
