import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label; // 👈 thêm biến label
final bool obscureText;
final controller;
  final Widget? prefixIcon; // ← thêm nếu chưa có
  const CustomTextField({super.key, required this.label,required this.obscureText,required this.controller,this.prefixIcon}); // 👈 nhận label từ constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: label, // 👈 dùng label ở đây
          prefixIcon: prefixIcon, // ← sử dụng nó ở đây
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black54,
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
