import 'package:el_wedding/core/theme.dart';
import 'package:el_wedding/core/validation.dart';
import 'package:el_wedding/core/widgets/text_field_custom.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

final emailController = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordEmailSentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sent Success.!")),
            );
            context.go("/LoginView");
          }
          if (state is ForgotPasswordEmailSentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to send email.!")),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enter Your Email',
                  style: AppTheme.largeText.copyWith(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldCustom(
                      icon: const Icon(Icons.email),
                      controller: emailController,
                      hintText: "Context@example.com",
                      border: const OutlineInputBorder(),
                      obscureText: false,
                      validator: ValidationApp.validateEmail),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<AuthCubit>()
                          .forgetPassword(emailController.text);
                    }
                  },
                  child: state is ForgotPasswordLoading
                      ? const CircularProgressIndicator()
                      : const Text('Forgot Password'),
                ),
                const SizedBox(height: 16),
                const Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      context.go("/RegisterView");
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: AppTheme.maincolor),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
