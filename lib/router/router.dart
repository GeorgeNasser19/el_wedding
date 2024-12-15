import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/check_auth.dart';
import 'package:el_wedding/core/widgets/error_page.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:el_wedding/features/auth/presentation/views/forget_password_view.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/register_view.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/employe_edit_profile_body.dart';
import 'package:el_wedding/features/select_role/data/select_role_repo_impl.dart';
import 'package:el_wedding/features/select_role/domain/usecase_select_role/usecase_select_role.dart';
import 'package:el_wedding/features/select_role/presentation/cubit/select_role_cubit.dart';
import 'package:el_wedding/features/select_role/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/employesViews/presentation/views/empolye_profile.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Route for the CheckAuthPage
      GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
                create: (context) =>
                    SelectRoleCubit(UsecaseSelectRole(SelectRoleRepoImpl())),
                child: const CheckAuthPage(),
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
                firebaseAuth: FirebaseAuth.instance,
                firestore: FirebaseFirestore.instance))),
            child: SelectRoleView(),
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
        path: '/EmpolyeEditProfile',
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
        path: '/EmployeEditProfileBody',
        builder: (context, state) {
          final employesModel = state.extra as EmployeeModel;
          return EmployeEditProfileBody(
            employesModel: employesModel,
          );
        },
      ),
      GoRoute(
        path: '/UserView',
        builder: (context, state) {
          return const UserView();
        },
      ),
    ],
  );
}
