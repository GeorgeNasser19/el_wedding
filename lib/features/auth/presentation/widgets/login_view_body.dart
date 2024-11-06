import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_custom.dart';
import '../../../../core/widgets/text_field_custom.dart';
import '../cubit/auth_cubit/auth_cubit_cubit.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  // Controllers for email and password input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Selected role for user, initially null
  String? selectedRole;

  // List of roles available in the app
  final List<String> roles = ["User", "Photographer", "Makeup Artist"];

  // Boolean to toggle password visibility
  bool isPasswordVisible = true;

  // Error text if any input is invalid
  String? errorText;

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
      context.read<AuthCubitCubit>().login(
            emailController.text,
            passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthCubitCubit, AuthState>(
        listener: (context, state) {
          // Listener to handle various states and navigate accordingly
          if (state is GoogleLoaded) {
            context.go("/"); // Navigate to login view on Google sign-in success
          }
          if (state is GoogleFauilar) {
            // Show error message if Google sign-in fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is GoogleNewUser) {
            // Navigate to role selection view for new Google users
            context.go("/selectRoleView");
          }
          if (state is LoginLoaded) {
            // Navigate to home page on login success
            context.go("/");
          }
          if (state is LoginFauilar) {
            // Show error message if login fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: TextCustom(
                    // text Custom
                    text: "Log in", // Login header text
                    style: AppTheme.largeText.copyWith(fontSize: 42),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                    const SizedBox(height: 12),
                    // Email input field
                    _buildTextField("Email", "contact@gmail.com",
                        emailController, validateEmail),
                    const SizedBox(height: 12),
                    // Password input field
                    _buildTextField(
                        icon: IconButton(
                          // function for switch password icons and visibility
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: isPasswordVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                        "Password",
                        "**********",
                        passwordController,
                        validatePassword,
                        isPassword: true),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          context.go("/forgotPasswordView");
                        },
                        child: Text(
                          "Forget Password ?", // Forgot password button
                          style: AppTheme.smallText.copyWith(fontSize: 14),
                        )),
                  ],
                ),
                // Login button
                ButtonCustom(
                  onpressed: validateAndSubmit,
                  bgColor: AppTheme.maincolor,
                  child: state is LoginLoading
                      ? const CircularProgressIndicator() // Show loading indicator during login
                      : Text(
                          "LOG IN",
                          style:
                              AppTheme.meduimText.copyWith(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 26),
                // Divider with "Or Log in With" text
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Or Log in With", // Text between dividers
                        style: AppTheme.meduimText,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Google login button
                ButtonCustom(
                    onpressed: context.read<AuthCubitCubit>().signInWithGoogle,
                    bgColor: Colors.white,
                    child: state is GoogleLoading
                        ? const CircularProgressIndicator() // Show loading indicator during Google sign-in
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "lib/assets/Google Logo.png",
                                scale: 5,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text("Log in With Gmail",
                                  style: AppTheme.meduimText)
                            ],
                          )),
                const SizedBox(height: 10),
                // Sign-up prompt if user does not have an account
                TextButton(
                  onPressed: () {
                    context.go('/RegisterView');
                  },
                  child: const Text(
                    "If you dont have account ! please Sign up Here ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget to build text fields with custom settings
  Widget _buildTextField(String label, String hint,
      TextEditingController controller, String? Function(String?) validator,
      {bool isPassword = false, Widget? icon}) {
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
}

// Function to validate email input
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  // Check if email is in valid format
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

// Function to validate password input
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  return null;
}
