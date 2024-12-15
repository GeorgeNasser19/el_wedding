import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/scaffold_message.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/button_custom.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({
    super.key,
    required this.validateAndSubmit,
  });

  final VoidCallback validateAndSubmit;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoaded) {
          // Navigate to home page on login success
          context.go(
            "/",
          );
        }
        if (state is RegisterFauilar) {
          // Show error message if login fails
          ScaffoldMessageApp.snakeBar(context, state.message);
        }
      },
      builder: (context, state) {
        return ButtonCustom(
          onpressed: validateAndSubmit,
          bgColor: AppTheme.maincolor,
          child: state is RegisterLoading
              ? const CircularProgressIndicator() // Show loading indicator during login
              : Text(
                  "SIGN UP",
                  style: AppTheme.meduimText.copyWith(color: Colors.white),
                ),
        );
      },
    );
  }
}
