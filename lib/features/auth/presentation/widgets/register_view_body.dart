import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_custom.dart';
import '../../../../core/widgets/text_field_custom.dart';
import '../cubit/auth_cubit/auth_cubit_cubit.dart';

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  final List<String> roles = ["User", "Photographer", "Makeup Artist"];
  bool isPasswordVisible = true;
  String? errorText;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateAndSubmit() {
    if (_formkey.currentState!.validate()) {
      if (selectedRole == null) {
        setState(() {
          errorText = "Please select a role.";
        });
      } else {
        errorText = null;
        context.read<AuthCubitCubit>().register(
              nameController.text,
              emailController.text,
              passwordController.text,
              selectedRole!,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthCubitCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterLoaded) {
            context.go("/loginView");
          }
          if (state is RegisterFauilar) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

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
        },
        builder: (context, state) {
          return Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: TextCustom(
                    text: "Sign Up",
                    style: AppTheme.largeText.copyWith(fontSize: 42),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                    _buildTextField("Full Name", "Your Name Here",
                        nameController, validateName),
                    const SizedBox(height: 12),
                    _buildTextField("Email", "contact@gmail.com",
                        emailController, validateEmail),
                    const SizedBox(height: 12),
                    _buildTextField("Password", "**********",
                        passwordController, validatePassword,
                        isPassword: true),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedRole,
                  hint: const Text("Select Role"),
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: (role),
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedRole = newValue;
                      errorText = null;
                    });
                  },
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ButtonCustom(
                  onpressed: validateAndSubmit,
                  bgColor: AppTheme.maincolor,
                  child: state is RegisterLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "SIGN UP",
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
                        "Or Sign Up With",
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
                              Text("SIGN UP With Gmail",
                                  style: AppTheme.meduimText)
                            ],
                          )),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.go('/loginView');
                  },
                  child: const Text(
                    "Already Have An Account ? Sign In Here",
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
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(value)) {
    return 'Password must include uppercase, lowercase and a number';
  }
  return null;
}

// دالة تحقق الاسم
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  if (value.length < 3) {
    return 'Name must be at least 3 characters long';
  }
  return null;
}
