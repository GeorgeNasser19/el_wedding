import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  const TextCustom({
    super.key,
    required this.text,
    required this.style,
    this.alignment,
  });

  final String text;
  final TextStyle style;
  final TextAlign? alignment;

  @override
  Widget build(
    context,
  ) {
    return Text(
      text,
      style: style,
      textAlign: alignment,
    );
  }
}
