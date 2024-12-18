import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/scaffold_message.dart';
import '../../../../core/theme.dart';
import '../../../auth/data/model/user_model.dart';

class SelectRoleView extends StatefulWidget {
  const SelectRoleView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectRoleViewState createState() => _SelectRoleViewState();
}

class _SelectRoleViewState extends State<SelectRoleView> {
  final key = GlobalKey<FormState>();
  final List<UserRole> getUserRole = [
    UserRole.user,
    UserRole.makeupArtist,
    UserRole.photographer,
  ];

  UserRole? _selectedRole;

  void validateAndSubmit() {
    if (key.currentState!.validate() && _selectedRole != null) {
      _submitRole();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Choose Your Role',
              style: TextStyle(color: Colors.black)),
        ),
        body: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(scale: 2, "lib/assets/images/wedding logo.png"),
                const Text(
                  'Please select your role:',
                  style: TextStyle(fontSize: 20),
                ),
                ...getUserRole.map((role) => RadioListTile<UserRole>(
                      activeColor: AppTheme.maincolor,
                      selectedTileColor: Colors.blue.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      splashRadius: 10,
                      title: Text(role.name),
                      value: role,
                      groupValue: _selectedRole,
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                    )),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is SaveDateLoaded) {
                      ScaffoldMessageApp.snakeBar(context, "Success");
                      context.go("/");
                    }
                    if (state is SaveDateFailur) {
                      ScaffoldMessageApp.snakeBar(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(
                            Size(double.infinity, 60)),
                        backgroundColor: WidgetStatePropertyAll(
                          AppTheme.maincolor,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        elevation: const WidgetStatePropertyAll(5),
                      ),
                      onPressed:
                          _selectedRole != null ? validateAndSubmit : null,
                      child: state is SaveDateLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitRole() async {
    FocusScope.of(context).unfocus();
    if (_selectedRole != null) {
      await context.read<AuthCubit>().setData(_selectedRole!.name);
    }
  }
}
