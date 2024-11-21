import 'package:flutter/material.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/input_feild_with_text.dart';
import '../../../../core/scaffold_message.dart';
import '../../../../core/theme.dart';
import '../../../../core/validation.dart';
import '../../../../core/widgets/button_custom.dart';
import '../cubit/auth_cubit/auth_cubit.dart';
import 'auth_drop_down_button.dart';
import 'auth_header.dart';
import 'auth_input_field.dart';

class RegisterViewContent extends StatefulWidget {
  const RegisterViewContent({super.key});

  @override
  State<RegisterViewContent> createState() => _RegisterViewContentState();
}

class _RegisterViewContentState extends State<RegisterViewContent> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserRole? selectedRole; // Updated to use UserRole enum
  bool isPasswordVisible = true;
  String? errorText;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      if (selectedRole == null) {
        setState(() {
          errorText = "Please select a role.";
        });
      } else {
        errorText = null;
        context.read<AuthCubit>().register(
              emailController.text,
              passwordController.text,
              nameController.text,
              selectedRole.toString().split('.').last, // Pass role as string
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterLoaded) {
            context.go("/");
          } else if (state is RegisterFauilar) {
            ScaffoldMessageApp.snakeBar(context, state.message);
          } else if (state is GoogleNewUser) {
            context.go("/selectRoleView");
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                const AuthHeader(auth: "Sign Up"),
                const SizedBox(height: 5),

                // Form Fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthInputFields(
                        formkey: _formKey,
                        emailController: emailController,
                        passwordController: passwordController,
                        isPasswordVisible: isPasswordVisible,
                        togglePasswordVisibility: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        extraWidget: buildTextField(
                          "User Name",
                          "Name",
                          nameController,
                          ValidationApp.validateName,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dropdown for Roles
                RoleDropdown(
                  selectedRole: selectedRole,
                  onRoleChanged: (newRole) {
                    setState(() {
                      selectedRole = newRole;
                      errorText = null;
                    });
                  },
                  errorText: errorText,
                ),

                // Submit Button
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
              ],
            ),
          );
        },
      ),
    );
  }
}
