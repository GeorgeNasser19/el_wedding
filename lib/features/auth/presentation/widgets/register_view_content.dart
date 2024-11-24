import 'package:el_wedding/core/helpers/input_feild_with_text.dart';
import 'package:el_wedding/core/validation.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/presentation/widgets/auth_drop_down_button.dart';
import 'package:el_wedding/features/auth/presentation/widgets/auth_header.dart';
import 'package:el_wedding/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:el_wedding/features/auth/presentation/widgets/button_for_sign_in_view.dart';
import 'package:el_wedding/features/auth/presentation/widgets/button_google.dart';
import 'package:el_wedding/features/auth/presentation/widgets/divider_with_or_text.dart';
import 'package:el_wedding/features/auth/presentation/widgets/signup_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit/auth_cubit.dart';

class RegisterViewContent extends StatefulWidget {
  const RegisterViewContent({super.key});

  @override
  State<RegisterViewContent> createState() => _RegisterViewContentState();
}

class _RegisterViewContentState extends State<RegisterViewContent> {
  // Controllers for email , password and username input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // string field for role selected
  UserRole? selectedRole;
  // List of roles for dropdown menu
  // boolean field for visibility
  bool isPasswordVisible = true;
  // String field for text error message from unSelected role
  String? errorText;
  // Form key for form validation
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to free up memory
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to validate form and initiate registration
  void validateAndSubmit() {
    if (_formkey.currentState!.validate()) {
      if (selectedRole == null) {
        // Display error if no role is selected
        setState(() {
          errorText = "Please select a role.";
        });
      } else {
        errorText = null;
        // Call the register function from AuthCubit with user inputs
        context.read<AuthCubit>().register(
              emailController.text,
              passwordController.text,
              nameController.text,
              selectedRole.toString(),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const AuthHeader(auth: "Sign Up"),
        const SizedBox(height: 20),
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
          extraWidget: buildTextField(
              design: true,
              "User Name",
              "Name",
              nameController,
              ValidationApp.validateName),
        ), // Dropdown menu for selecting role
        RoleDropdown(
          onRoleChanged: (newValue) {
            setState(() {
              selectedRole = newValue;
              errorText = null;
            });
          },
          selectedRole: selectedRole,
        ),
        // Error Text for Unselecting role
        Text(
          errorText ?? "",
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 5),
        // Custom button for submitting registration form
        SignupButton(validateAndSubmit: validateAndSubmit),
        const SizedBox(height: 26),
        // Divider with text for alternative sign-up method
        const DividerWithOrText(
          text: "Or sign up with",
        ),
        // Custom button for Google Sign-Up
        const ButtonGoogle(
          text: "Sign Up with Gmail",
        ),
        const SizedBox(height: 10),
        // Link to navigate to the login page
        const ButtonForSignIn()
      ],
    ));
  }
}
