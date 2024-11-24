import 'package:el_wedding/core/helpers/input_feild_with_text.dart';
import 'package:el_wedding/core/validation.dart';
import 'package:flutter/material.dart';

class TextFeildsInEmpolyesView extends StatelessWidget {
  const TextFeildsInEmpolyesView(
      {super.key,
      required this.userName,
      required this.fname,
      required this.description,
      required this.location,
      required this.pNumber});

  final String userName;
  final TextEditingController fname;
  final TextEditingController description;
  final TextEditingController location;
  final TextEditingController pNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(
            design: true,
            "Full Name",
            userName,
            fname,
            ValidationApp.validateProfileSetup),
        const SizedBox(height: 16),
        buildTextField(
            design: true,
            "Location",
            "Sohag",
            location,
            ValidationApp.validateProfileSetup),
        const SizedBox(height: 16),
        buildTextField(
            design: true,
            keyboardType: TextInputType.phone,
            "Phone Number",
            "+201000000000",
            pNumber,
            ValidationApp.validateProfileSetup),
        const SizedBox(height: 16),
        buildTextField(
            textInputAction: TextInputAction.newline,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            design: true,
            maxline: 5,
            "Description",
            "Write a brief description...",
            description,
            ValidationApp.validateProfileSetup),
      ],
    );
  }
}
