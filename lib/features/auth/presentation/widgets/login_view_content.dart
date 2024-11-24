import 'package:el_wedding/features/auth/presentation/widgets/button_google.dart';
import 'package:el_wedding/features/auth/presentation/widgets/forget_pass_button.dart';
import 'package:el_wedding/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:el_wedding/features/auth/presentation/widgets/login_button.dart';
import 'package:el_wedding/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit/auth_cubit.dart';
import 'button_for_sign_up_view.dart';
import 'divider_with_or_text.dart';

class LoginViewContent extends StatefulWidget {
  const LoginViewContent({super.key});

  @override
  State<LoginViewContent> createState() => _LoginViewContentState();
}

class _LoginViewContentState extends State<LoginViewContent> {
  // Controllers for email and password input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Boolean to toggle password visibility
  bool isPasswordVisible = true;

  // Form key to validate and manage form state
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to free up resources when the widget is removed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to validate form inputs and submit login request
  void validateAndSubmit() {
    if (_formkey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            emailController.text,
            passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 5),
        const AuthHeader(
          auth: 'Log in',
        ),
        AuthInputFields(
          formkey: _formkey,
          emailController: emailController,
          passwordController: passwordController,
          togglePasswordVisibility: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          isPasswordVisible: isPasswordVisible,
        ),
        const ForgetPassButton(),
        // Login button
        LoginButton(validateAndSubmit: validateAndSubmit),
        const SizedBox(height: 26),
        // Divider with "Or Log in With" text
        const DividerWithOrText(
          text: 'Or Login With',
        ),
        const SizedBox(height: 32),
        // Google login button
        const ButtonGoogle(
          text: "Log in With Gmail",
        ),
        const SizedBox(height: 10),
        // Sign-up prompt if user does not have an account
        const ButtonForSignUpView()
      ],
    ));
  }
}
