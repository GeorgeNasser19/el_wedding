import 'package:el_wedding/features/employesViews/presentation/widgets/text_feilds_in_empolyes_view.dart';
import 'package:flutter/material.dart';

class InputFieldEdit extends StatelessWidget {
  const InputFieldEdit(
      {super.key,
      required this.username,
      required this.fname,
      required this.description,
      required this.location,
      required this.pNumber});

  final String username;
  final TextEditingController fname;
  final TextEditingController description;
  final TextEditingController location;
  final TextEditingController pNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: TextFeildsInEmpolyesView(
            userName: username,
            fname: fname,
            description: description,
            location: location,
            pNumber: pNumber));
  }
}
