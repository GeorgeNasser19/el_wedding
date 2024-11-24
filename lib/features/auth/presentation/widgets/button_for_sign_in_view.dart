import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ButtonForSignIn extends StatelessWidget {
  const ButtonForSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go('/loginView');
      },
      child: const Text(
        "Already Have An Account ? Sign In Here",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
