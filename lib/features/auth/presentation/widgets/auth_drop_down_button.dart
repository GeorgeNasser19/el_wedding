import 'package:flutter/material.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';

class RoleDropdown extends StatelessWidget {
  final UserRole? selectedRole; // Using UserRole enum directly
  final ValueChanged<UserRole?> onRoleChanged; // Callback function
  final String? errorText; // Error message (optional)

  const RoleDropdown({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<UserRole>(
          value: selectedRole,
          hint: const Text("Select Role"),
          items: UserRole.values.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role.name), // Get a readable name for the enum
            );
          }).toList(),
          onChanged: onRoleChanged,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(errorText!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
