import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {super.key,
      required this.controller,
      required this.hintText,
      this.style,
      this.icon,
      required this.border,
      required this.obscureText,
      required this.validator});

  final TextEditingController controller;
  final String hintText;
  final InputBorder border;
  final TextStyle? style;
  final Widget? icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: GlobalKey(),
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        border: border,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelStyle: style,
        suffixIcon: icon,
      ),
    );
  }
}
