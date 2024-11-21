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
        TextFormField(
          controller: fname,
          // initialValue: userName,
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: location,
          decoration: const InputDecoration(labelText: 'Location'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: pNumber,
          decoration: const InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: description,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
      ],
    );
  }
}
