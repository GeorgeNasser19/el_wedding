import 'package:el_wedding/features/auth/presentation/widgets/register_view_content.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({
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
                      RegisterViewContent(),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
