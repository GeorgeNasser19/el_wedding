// lib/helpers/input_field_helper.dart

import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/text_custom.dart';
import '../widgets/text_field_custom.dart';

// Helper function to build text fields with custom settings
Widget buildTextField(
  String label,
  String hint,
  TextEditingController controller,
  String? Function(String?) validator, {
  bool isPassword = false,
  Widget? icon,
  bool isPasswordVisible = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextCustom(
        text: label, // Label text for the input field
        style: AppTheme.largeText.copyWith(fontSize: 14),
        alignment: TextAlign.left,
      ),
      TextFieldCustom(
        icon: icon,
        hintText: hint, // Hint text for the input field
        style: AppTheme.meduimText,
        controller: controller,
        border: const OutlineInputBorder(),
        validator: validator, // Field validation function
        obscureText:
            isPassword ? isPasswordVisible : false, // Show/hide password text
      ),
    ],
  );
}
