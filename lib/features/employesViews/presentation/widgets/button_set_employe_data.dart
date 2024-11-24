import 'package:el_wedding/core/scaffold_message.dart';
import 'package:el_wedding/features/employesViews/presentation/employes_cubit/employes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  saveData();
                }
              },
              child: state is SaveDataLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
