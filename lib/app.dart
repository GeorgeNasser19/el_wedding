import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/core/shared_services/shared_services_rpeo_imp/shared_services_repo_impl.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:el_wedding/features/employesViews/data/employes_repo_imp.dart';
import 'package:el_wedding/features/employesViews/domain/usecase/employ_repo_usecase.dart';
import 'package:el_wedding/features/employesViews/presentation/employes_cubit/employes_cubit.dart';
import 'package:el_wedding/router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ElWedding extends StatelessWidget {
  const ElWedding({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepoUsecase(AuthRepoImp(
              googleSignIn: GoogleSignIn(),
              firebaseAuth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance))),
        ),
        BlocProvider(
          create: (context) => EmployesCubit(
              EmployRepoUsecase(EmployesRepoImp()),
              SharedServicesUsecase(SharedServicesRepoImpl())),
        )
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
