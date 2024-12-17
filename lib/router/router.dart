import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/core/shared_services/shared_services_rpeo_imp/shared_services_repo_impl.dart';
import 'package:el_wedding/core/widgets/error_page.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:el_wedding/features/auth/presentation/cubit/check_auth_cubit/check_auth_cubit.dart';
import 'package:el_wedding/features/auth/presentation/views/check_auth_view.dart';
import 'package:el_wedding/features/auth/presentation/views/forget_password_view.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/register_view.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/views/employee_edit_profile_page.dart';
import 'package:el_wedding/features/employesViews/presentation/views/galary_page.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/employe_edit_profile_contant.dart';
import 'package:el_wedding/features/select_role/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter_page.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../features/employesViews/presentation/views/empolye_profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Route for the CheckAuthPage
      GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
                create: (context) => CheckAuthCubit(
                    AuthRepoUsecase(AuthRepoImp(
                        googleSignIn: GoogleSignIn(),
                        firebaseAuth: FirebaseAuth.instance,
                        firestore: FirebaseFirestore.instance)),
                    SharedServicesUsecase(SharedServicesRepoImpl()))
                  ..checkAuth(),
                child: const CheckAuthView(),
              )),
      // Route for RegisterView
      GoRoute(
          path: '/RegisterView',
          builder: (context, state) {
            return const RegisterView();
          }),
      // Route for LoginView
      GoRoute(
          path: '/loginView',
          builder: (context, state) {
            return const LoginView();
          }),
      // Route for SelectRoleView
      GoRoute(
        path: '/SelectRoleView',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => AuthCubit(AuthRepoUsecase(AuthRepoImp(
                googleSignIn: GoogleSignIn(),
                firebaseAuth: FirebaseAuth.instance,
                firestore: FirebaseFirestore.instance))),
            child: const SelectRoleView(),
          );
        },
      ),

      // Route for ForgetPasswordView
      GoRoute(
        path: '/forgotPasswordView',
        builder: (context, state) => const ForgetPasswordView(),
      ),
      // Route for EmpolyeProfileFirstEnter with dynamic data
      GoRoute(
        path: '/EmpolyeProfileFirstEnter',
        builder: (context, state) {
          final extra = state.extra as String;
          return EmpolyeProfileFirstEnter(userName: extra);
        },
      ),
      GoRoute(
        path: '/EmpolyeProfile',
        builder: (context, state) {
          final employesModel = state.extra as EmployeeModel;
          return EmpolyeProfile(employesModel: employesModel);
        },
      ),
      GoRoute(
        path: '/errorPage',
        builder: (context, state) {
          return const ErrorPage();
        },
      ),
      GoRoute(
        path: '/EmployeEditProfileContant',
        builder: (context, state) {
          final employesModel = state.extra as EmployeeModel;
          return EmployeEditProfileContant(
            employesModel: employesModel,
          );
        },
      ),
      GoRoute(
        path: '/UserView',
        builder: (context, state) {
          final userModel = state.extra as UserModel;
          return UserView(
            userModel: userModel,
          );
        },
      ),

      GoRoute(
        path: '/EmployeeEditProfile',
        pageBuilder: (context, state) {
          final employeeModel = state.extra as EmployeeModel;

          return CustomTransitionPage(
            child: EmployeeEditProfile(employeeModel: employeeModel),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Fade transition
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/GalaryPage',
        pageBuilder: (context, state) {
          final images = state.extra as List<String>;

          return CustomTransitionPage(
            child: GalaryPage(images: images),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Fade transition
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
