import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_wedding/features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/user_model.dart';

class UserView extends StatelessWidget {
  const UserView({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "welcome ${userModel.fName}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // employee image
          // Container(
          //   height: 150,
          //   margin: const EdgeInsets.only(top: 24),
          //   child: ClipOval(
          //     child: CachedNetworkImage(
          //       imageUrl: userModel.imageUrl,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // employee full name
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Text(userModel.fName, style: const TextStyle(fontSize: 20)),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SignOutSuccess) {
                context.go(
                  "/LoginView",
                );
              }
              if (state is SignOutFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                child: state is SignOutLoading
                    ? const CircularProgressIndicator()
                    : const Text("Log Out",
                        style: TextStyle(fontSize: 15, color: Colors.black)),
              );
            },
          ),
        ],
      ),
    ));
  }
}
