import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/scaffold_message.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/button_custom.dart';
import '../cubit/auth_cubit/auth_cubit.dart';

class ButtonGoogle extends StatelessWidget {
  const ButtonGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is GoogleLoaded) {
          context.go("/"); // Navigate to login view on Google sign-in success
        }
        if (state is GoogleFauilar) {
          // Show error message if Google sign-in fails
          ScaffoldMessageApp.snakeBar(context, state.message);
        }
        if (state is GoogleNewUser) {
          // Navigate to role selection view for new Google users
          context.go("/selectRoleView");
        }
      },
      builder: (context, state) {
        return ButtonCustom(
            onpressed: context.read<AuthCubit>().signInWithGoogle,
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
                      Text("Log in With Gmail", style: AppTheme.meduimText),
                    ],
                  ));
      },
    );
  }
}
