import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class EmpolyeEditProfile extends StatefulWidget {
  const EmpolyeEditProfile({super.key, required this.employesModel});

  final EmployesModel employesModel;

  @override
  State<EmpolyeEditProfile> createState() => _EmpolyeEditProfileState();
}

class _EmpolyeEditProfileState extends State<EmpolyeEditProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: FileImage(
                widget.employesModel.image!,
              ),
            ),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SignOutSuccess) {
                context.go("/LoginView");
              }
              if (state is SignOutFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                  },
                  child: state is SignOutLoading
                      ? const CircularProgressIndicator()
                      : const Text("LogOut"));
            },
          ),
        ],
      )),
    );
  }
}
