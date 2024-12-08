import 'package:el_wedding/check_auth.dart';
import 'package:el_wedding/core/widgets/error_page.dart';
import 'package:el_wedding/features/auth/presentation/views/forget_password_view.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/register_view.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/select_role/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter.dart';
import 'package:go_router/go_router.dart';

import '../features/employesViews/presentation/views/empolye_edit_profile.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Route for the CheckAuthPage
      GoRoute(path: '/', builder: (context, state) => const CheckAuthPage()),
      // Route for RegisterView
      GoRoute(
        path: '/RegisterView',
        builder: (context, state) => const RegisterView(),
      ),
      // Route for LoginView
      GoRoute(
        path: '/loginView',
        builder: (context, state) => const LoginView(),
      ),
      // Route for SelectRoleView
      GoRoute(
        path: '/selectRoleView',
        builder: (context, state) => const SelectRoleView(),
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
          return EmpolyeEditProfile(employesModel: employesModel);
        },
      ),
      GoRoute(
        path: '/errorPage',
        builder: (context, state) {
          return const ErrorPage();
        },
      ),
    ],
  );
}
