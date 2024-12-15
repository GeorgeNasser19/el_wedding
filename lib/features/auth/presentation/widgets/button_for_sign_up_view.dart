import 'package:el_wedding/core/helpers/sheard_pref.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonForSignUpView extends StatelessWidget {
  const ButtonForSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go('/RegisterView');
        SharedPrefs().remove("role_user");
      },
      child: const Text(
        "If you dont have account ! please Sign up Here ",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
