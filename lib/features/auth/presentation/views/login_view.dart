import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubitCubit(AuthRepoUsecase(AuthRepoImp(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance))),
        child: const SafeArea(
          child: Center(
            child: Form(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LoginViewBody(),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
