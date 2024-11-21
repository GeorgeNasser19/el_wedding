import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/scaffold_message.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/button_custom.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.validateAndSubmit});

  final VoidCallback validateAndSubmit;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoaded) {
          // Navigate to home page on login success
          context.go("/");
        }
        if (state is LoginFauilar) {
          // Show error message if login fails
          ScaffoldMessageApp.snakeBar(context, state.message);
        }
      },
      builder: (context, state) {
        return ButtonCustom(
          onpressed: validateAndSubmit,
          bgColor: AppTheme.maincolor,
          child: state is LoginLoading
              ? const CircularProgressIndicator() // Show loading indicator during login
              : Text(
                  "LOG IN",
                  style: AppTheme.meduimText.copyWith(color: Colors.white),
                ),
        );
      },
    );
  }
}
