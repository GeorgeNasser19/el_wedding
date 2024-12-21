import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
    );
  }
}
