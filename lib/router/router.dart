import 'package:el_wedding/core/di.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:el_wedding/features/auth/presentation/cubit/check_auth_cubit/check_auth_cubit.dart';
import 'package:el_wedding/features/auth/presentation/views/check_auth_view.dart';
import 'package:el_wedding/features/auth/presentation/views/forget_password_view.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/register_view.dart';
import 'package:el_wedding/features/auth/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/employes_cubit/employes_cubit.dart';
import 'package:el_wedding/features/employesViews/presentation/views/employe_profile_contant_page.dart';
import 'package:el_wedding/features/employesViews/presentation/views/employee_edit_profile_page.dart';
import 'package:el_wedding/features/employesViews/presentation/views/galary_page.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter_page.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';
import 'package:el_wedding/features/userView/presentation/cubit/user_view_cubit.dart';
import 'package:el_wedding/features/userView/presentation/views/user_enter_profile.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/employesViews/presentation/views/empolye_profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Route for the CheckAuthPage
      GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
                create: (context) =>
                    DependancyInjection().locator<CheckAuthCubit>()
                      ..checkAuth(),
                child: const CheckAuthView(),
              )),
      // Route for RegisterView
      GoRoute(
          path: '/RegisterView',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => DependancyInjection().locator<AuthCubit>(),
              child: const RegisterView(),
            );
          }),
      // Route for LoginView
      GoRoute(
          path: '/loginView',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => DependancyInjection().locator<AuthCubit>(),
              child: const LoginView(),
            );
          }),
      // Route for SelectRoleView
      GoRoute(
        path: '/SelectRoleView',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => DependancyInjection().locator<AuthCubit>(),
            child: const SelectRoleView(),
          );
        },
      ),

      // Route for ForgetPasswordView
      GoRoute(
        path: '/forgotPasswordView',
        builder: (context, state) => BlocProvider(
          create: (context) => DependancyInjection().locator<AuthCubit>(),
          child: const ForgetPasswordView(),
        ),
      ),
      // Route for EmpolyeProfileFirstEnter with dynamic data
      GoRoute(
        path: '/EmpolyeProfileFirstEnter',
        builder: (context, state) {
          final extra = state.extra as String;
          return BlocProvider(
            create: (context) => DependancyInjection().locator<EmployesCubit>(),
            child: EmpolyeProfileFirstEnter(userName: extra),
          );
        },
      ),
      GoRoute(
        path: '/EmpolyeProfile',
        builder: (context, state) {
          final employesModel = state.extra as EmployeeModel;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    DependancyInjection().locator<EmployesCubit>(),
              ),
              BlocProvider(
                create: (context) => DependancyInjection().locator<AuthCubit>(),
              ),
            ],
            child: EmpolyeProfile(employesModel: employesModel),
          );
        },
      ),
      GoRoute(
        path: '/EmployeEditProfileContant',
        builder: (context, state) {
          final employesModel = state.extra as EmployeeModel;
          return BlocProvider(
            create: (context) => DependancyInjection().locator<AuthCubit>(),
            child: EmployeProfileContantPage(
              employesModel: employesModel,
            ),
          );
        },
      ),
      GoRoute(
        path: '/UserView',
        builder: (context, state) {
          // تمرير البيانات كـ Map
          final userModel = state.extra as UserModel;

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    DependancyInjection().locator<UserViewCubit>(),
              ),
              BlocProvider(
                create: (context) => DependancyInjection().locator<AuthCubit>(),
              ),
            ],
            child: UserView(
              userModel: userModel,
            ),
          );
        },
      ),

      GoRoute(
        path: '/EmployeeEditProfile',
        pageBuilder: (context, state) {
          final employeeModel = state.extra as EmployeeModel;

          return CustomTransitionPage(
            child: BlocProvider(
              create: (context) =>
                  DependancyInjection().locator<EmployesCubit>(),
              child: EmployeeEditProfile(employeeModel: employeeModel),
            ),
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
      GoRoute(
        path: '/UserEnterProfile',
        builder: (context, state) {
          final extra = state.extra as String;

          return BlocProvider(
            create: (context) => DependancyInjection().locator<UserViewCubit>(),
            child: UserEnterProfile(
              username: extra,
            ),
          );
        },
      ),
    ],
  );
}
