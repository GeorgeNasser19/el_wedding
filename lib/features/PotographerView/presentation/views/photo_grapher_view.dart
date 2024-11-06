import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PhotoGrapherView extends StatelessWidget {
  const PhotoGrapherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubitCubit(AuthRepoUsecase(AuthRepoImp(
          firebaseAuth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance))),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "PhotoGrapherView",
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<AuthCubitCubit, AuthState>(
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
                        context.read<AuthCubitCubit>().logout();
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
