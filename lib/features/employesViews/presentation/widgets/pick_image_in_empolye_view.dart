import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../employes_cubit/employes_cubit.dart';

// ignore: must_be_immutable
class PickImageInEmployeeView extends StatelessWidget {
  PickImageInEmployeeView({
    super.key,
    this.pickedImage,
    required this.onImagePicked,
  });

  File? pickedImage;
  final Function(File?) onImagePicked;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployesCubit, EmployesState>(
      listener: (context, state) {
        if (state is PickedIamgeFailur) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is PickedIamgeLoaded) {
          pickedImage = state.image;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onImagePicked(pickedImage);
          });
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              pickedImage != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(pickedImage!),
                    )
                  : CircleAvatar(
                      radius: 40,
                      child: IconButton(
                        onPressed: () {
                          context.read<EmployesCubit>().pickIamge(pickedImage);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
              const Text(
                'Add your Picture',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
