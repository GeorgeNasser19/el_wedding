import 'package:flutter/material.dart';

import '../widgets/login_view_content.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoginViewContent(),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
