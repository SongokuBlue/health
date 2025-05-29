import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label; // 👈 thêm biến label
final bool obscureText;
final controller;
  const CustomTextField({super.key, required this.label,required this.obscureText,required this.controller}); // 👈 nhận label từ constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: label, // 👈 dùng label ở đây
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.blueAccent,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
