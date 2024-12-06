import 'package:el_wedding/core/scaffold_message.dart';
import 'package:el_wedding/features/employesViews/presentation/employes_cubit/employes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ButtonSetEmployeeData extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback saveData;

  const ButtonSetEmployeeData({
    super.key,
    required this.formKey,
    required this.saveData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployesCubit, EmployesState>(
      listener: (context, state) {
        if (state is SaveDataFailur) {
          ScaffoldMessageApp.snakeBar(context, state.errorMessage);
        } else if (state is SaveDataLoaded) {
          ScaffoldMessageApp.snakeBar(context, "Success!");
          context.go("/EmpolyeEditProfile", extra: state.employesModel);
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
                child: state is SaveDataLoading
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
