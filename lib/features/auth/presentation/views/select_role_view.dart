import 'package:el_wedding/core/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SelectRoleView extends StatefulWidget {
  const SelectRoleView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectRoleViewState createState() => _SelectRoleViewState();
}

class _SelectRoleViewState extends State<SelectRoleView> {
  final passwordController = TextEditingController();

  final key = GlobalKey<FormState>();

  String? _selectedRole;

  final List<String> _roles = [
    'Photographer',
    'Makeup Artist',
    'User',
  ];

  void validateAndSubmit() {
    if (key.currentState!.validate()) {
      _submitRole();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Role',
            style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please select your role:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ..._roles.map((role) => RadioListTile<String>(
                    title: Text(role),
                    value: role,
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                  )),
              const SizedBox(height: 20),
              TextFieldCustom(
                  controller: passwordController,
                  hintText: "**********",
                  border: const OutlineInputBorder(),
                  obscureText: true,
                  validator: validatePassword),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedRole != null ? validateAndSubmit : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRole() async {
    if (_selectedRole != null) {
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
            {'role': _selectedRole, "password": passwordController.text});

        // ignore: use_build_context_synchronously
        context.go("/loginView");
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating role: $e')),
        );
      }
    }
  }
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(value)) {
    return 'Password must include uppercase, lowercase and a number';
  }
  return null;
}
