import 'package:el_wedding/features/userView/presentation/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/scaffold_message.dart';

class ButtonSetDate extends StatelessWidget {
  const ButtonSetDate(
      {super.key, required this.formKey, required this.saveData});
  final GlobalKey<FormState> formKey;
  final VoidCallback saveData;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserViewCubit, UserViewState>(
      listener: (context, state) {
        if (state is SetDateFauiler) {
          ScaffoldMessageApp.snakeBar(context, state.message);
        }
        if (state is SetDateLoaded) {
          ScaffoldMessageApp.snakeBar(context, 'Date set successfully');
          context.go("/UserView", extra: state.userModel);
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    saveData();
                  }
                },
                child: state is SetDateLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const Text('Save', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }
}
