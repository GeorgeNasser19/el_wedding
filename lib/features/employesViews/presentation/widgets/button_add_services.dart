import 'package:flutter/material.dart';

import '../../../../core/theme.dart';

class ButtonAddServices extends StatelessWidget {
  const ButtonAddServices(
      {super.key, required this.services, required this.onChange});

  final List<Map<String, dynamic>> services;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        Icons.add,
        color: AppTheme.maincolor,
      ),
      label: Text(
        'Add Service',
        style: TextStyle(color: AppTheme.maincolor),
      ),
      onPressed: () {
        services.add({'name': '', 'price': 0.0});
        onChange();
      },
    );
  }
}
