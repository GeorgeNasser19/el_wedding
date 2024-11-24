import 'package:flutter/material.dart';

class ButtonAddServices extends StatelessWidget {
  const ButtonAddServices(
      {super.key, required this.services, required this.onChange});

  final List<Map<String, dynamic>> services;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add),
      label: const Text('Add Service'),
      onPressed: () {
        services.add({'name': '', 'price': 0.0});
        onChange();
      },
    );
  }
}
