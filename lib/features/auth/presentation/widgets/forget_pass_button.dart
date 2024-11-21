import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme.dart';

class ForgetPassButton extends StatelessWidget {
  const ForgetPassButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              context.go("/forgotPasswordView");
            },
            child: Text(
              "Forget Password ?", // Forgot password button
              style: AppTheme.smallText.copyWith(fontSize: 14),
            )),
      ],
    );
  }
}
