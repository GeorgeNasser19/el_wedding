import 'package:flutter/material.dart';

import '../../../../core/helpers/input_feild_with_text.dart';
import '../../../../core/validation.dart';

class AuthInputFields extends StatelessWidget {
  const AuthInputFields({
    super.key,
    required this.formkey,
    required this.emailController,
    required this.passwordController,
    required this.togglePasswordVisibility,
    required this.isPasswordVisible,
    this.extraWidget, // widget الإضافية
  });

  final GlobalKey formkey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback togglePasswordVisibility;
  final Widget? extraWidget; // widget الحقل الإضافي

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          if (extraWidget != null) ...[
            extraWidget!,
          ],
          const SizedBox(height: 12),
          // Email input field
          buildTextField(
            design: true,
            "Email",
            "contact@gmail.com",
            emailController,
            ValidationApp.validateEmail,
          ),
          const SizedBox(height: 12),
          // Password input field
          buildTextField(
            maxline: 1,
            isPasswordVisible: isPasswordVisible,
            icon: IconButton(
              onPressed: togglePasswordVisibility,
              icon: isPasswordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            design: true,
            "Password",
            "**********",
            passwordController,
            ValidationApp.validatePassword,
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
