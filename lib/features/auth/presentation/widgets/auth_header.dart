import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import '../../../../core/widgets/text_custom.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.auth});

  final String auth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextCustom(
        // text Custom
        text: auth, // Login header text
        style: AppTheme.largeText.copyWith(fontSize: 42),
      ),
    );
  }
}
