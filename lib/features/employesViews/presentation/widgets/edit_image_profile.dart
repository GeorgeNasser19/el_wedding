import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_wedding/features/employesViews/presentation/employes_cubit/employes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class EditImageProfile extends StatelessWidget {
  EditImageProfile(
      {super.key,
      this.pickedImage,
      required this.image,
      required this.onImagePicked});

  final String image;

  final Function(File?) onImagePicked;
  File? pickedImage;
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
              Stack(
                children: [
                  ClipOval(
                      child: pickedImage != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(pickedImage!),
                            )
                          : CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 500),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.person),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl: image,
                            )),
                  Positioned(
                      bottom: -15,
                      right: -15,
                      child: SizedBox(
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(Icons.person_2),
                                        onPressed: () {
                                          context
                                              .read<EmployesCubit>()
                                              .pickIamge(pickedImage);
                                          context.pop();
                                        },
                                        label: const Text(
                                          "Show your Picture",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.pop(context);
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
