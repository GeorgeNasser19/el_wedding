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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  final List<String> roles = ["User", "Photographer", "Makeup Artist"];
  bool isPasswordVisible = true;
  String? errorText;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
          if (state is GoogleLoaded) {
            context.go("/loginView");
          }
          if (state is GoogleFauilar) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is GoogleNewUser) {
            context.go("/selectRoleView");
          }
          if (state is LoginLoaded) {
            context.go("/");
          }
          if (state is LoginFauilar) {
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
                    text: "Log in",
                    style: AppTheme.largeText.copyWith(fontSize: 42),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildTextField("Email", "contact@gmail.com",
                        emailController, validateEmail),
                    const SizedBox(height: 12),
                    _buildTextField("Password", "**********",
                        passwordController, validatePassword,
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
                          "Forget Password ?",
                          style: AppTheme.smallText.copyWith(fontSize: 14),
                        )),
                  ],
                ),
                ButtonCustom(
                  onpressed: validateAndSubmit,
                  bgColor: AppTheme.maincolor,
                  child: state is LoginLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "LOG IN",
                          style:
                              AppTheme.meduimText.copyWith(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 26),
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
                        "Or Log in With",
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
                ButtonCustom(
                    onpressed: context.read<AuthCubitCubit>().signInWithGoogle,
                    bgColor: Colors.white,
                    child: state is GoogleLoading
                        ? const CircularProgressIndicator()
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
                TextButton(
                  onPressed: () {
                    context.go('/');
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

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, String? Function(String?) validator,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
          text: label,
          style: AppTheme.largeText.copyWith(fontSize: 14),
          alignment: TextAlign.left,
        ),
        TextFieldCustom(
          hintText: hint,
          style: AppTheme.meduimText,
          controller: controller,
          border: const OutlineInputBorder(),
          validator: validator,
          obscureText: isPassword,
        ),
      ],
    );
  }
}

// دالة تحقق البريد الإلكتروني
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

// دالة تحقق كلمة المرور
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  return null;
}
