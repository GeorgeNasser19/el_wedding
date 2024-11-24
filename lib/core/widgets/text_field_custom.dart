import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {super.key,
      required this.controller,
      required this.hintText,
      this.style,
      this.hintmaxline,
      this.maxline,
      this.keyboardType,
      this.icon,
      required this.border,
      required this.obscureText,
      required this.validator,
      this.contentPadding,
      this.textInputAction});

  final TextEditingController controller;
  final String hintText;
  final InputBorder border;
  final TextStyle? style;
  final Widget? icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxline;
  final int? hintmaxline;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLines: maxline,
      key: GlobalKey(),
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintMaxLines: hintmaxline,
        border: border,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelStyle: style,
        suffixIcon: icon,
      ),
    );
  }
}
