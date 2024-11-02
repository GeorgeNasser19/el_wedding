import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit_cubit.dart';
import 'package:el_wedding/features/auth/presentation/views/forget_password_view.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/register_view.dart';
import 'package:el_wedding/features/auth/presentation/views/select_role_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const RegisterView();
        },
      ),
      GoRoute(
        path: '/loginView',
        builder: (context, state) {
          return const LoginView();
        },
      ),
      GoRoute(
        path: '/selectRoleView',
        builder: (context, state) {
          return const SelectRoleView();
        },
      ),
      GoRoute(
        path: '/forgotPasswordView',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => AuthCubitCubit(AuthRepoUsecase(AuthRepoImp(
                firebaseAuth: FirebaseAuth.instance,
                firestore: FirebaseFirestore.instance))),
            child: const ForgetPasswordView(),
          );
        },
      ),
    ],
  );
}
