import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/helpers/sheard_pref.dart';

class UserView extends StatelessWidget {
  const UserView(
      {super.key, required this.userModel, required this.employeeModel});

  final UserModel userModel;
  final EmployeeModel employeeModel;

  @override
  Widget build(BuildContext context) {
    final role = SharedPrefs().getString("role");

    return BlocProvider(
      create: (context) => AuthCubit(AuthRepoUsecase(AuthRepoImp(
          googleSignIn: GoogleSignIn(),
          firebaseAuth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance))),
      child: Scaffold(
        appBar: AppBar(
          title: Text(role ?? "no role"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "User View",
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is SignOutSuccess) {
                    context.go("/LoginView", extra: role);
                    SharedPrefs().remove("role_user");
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
