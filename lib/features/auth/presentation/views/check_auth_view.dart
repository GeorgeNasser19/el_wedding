import 'package:el_wedding/features/auth/presentation/cubit/check_auth_cubit/check_auth_cubit.dart';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckAuthView extends StatelessWidget {
  const CheckAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocConsumer<CheckAuthCubit, CheckAuthState>(
      listener: (context, state) {
        if (state is NoUser) {
          context.go("/LoginView");
        }
        if (state is NoSelectedRole) {
          context.go("/SelectRoleView");
        }
        if (state is UserLoaded) {
          context.go("/UserView", extra: state.userModel);
        }
        if (state is NoProfileComolete) {
          context.go("/EmpolyeProfileFirstEnter", extra: state.username);
        }
        if (state is ProfileComplete) {
          context.go("/EmpolyeProfile", extra: state.employeeModel);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ));
  }
}
