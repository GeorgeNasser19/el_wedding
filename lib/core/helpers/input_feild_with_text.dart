// lib/helpers/input_field_helper.dart

import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/text_custom.dart';
import '../widgets/text_field_custom.dart';

// Helper function to build text fields with custom settings
Widget buildTextField(String label, String hint,
    TextEditingController controller, String? Function(String?) validator,
    {bool isPassword = false,
    String? initialValue,
    Widget? icon,
    bool isPasswordVisible = false,
    int? maxline,
    int? maxlinehint,
    bool? design,
    EdgeInsetsGeometry? contentPadding,
    TextInputAction? textInputAction,
    TextAlign? textAlign,
    TextInputType? keyboardType}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextCustom(
        text: label, // Label text for the input field
        style: AppTheme.largeText.copyWith(fontSize: 14),
        alignment: TextAlign.left,
      ),
      Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: const Color.fromARGB(255, 83, 83, 83),
              width: 1.0,
            )),
        child: TextFieldCustom(
          initialValue: initialValue,
          hintmaxline: maxlinehint,
          keyboardType: keyboardType,
          maxline: maxline,
          icon: icon,
          hintText: hint, // Hint text for the input field
          style: AppTheme.meduimText,
          controller: controller,

          border: design!
              ? const OutlineInputBorder()
              : const UnderlineInputBorder(),
          validator: validator, // Field validation function
          obscureText:
              isPassword ? isPasswordVisible : false, // Show/hide password text
          contentPadding: contentPadding,
          textInputAction: textInputAction,
        ),
      ),
    ],
  );
}
