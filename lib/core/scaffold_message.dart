import 'package:flutter/material.dart';

class ScaffoldMessageApp {
  static snakeBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
