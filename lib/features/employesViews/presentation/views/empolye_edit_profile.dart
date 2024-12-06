import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class EmpolyeEditProfile extends StatelessWidget {
  const EmpolyeEditProfile({super.key, required this.employesModel});

  final EmployesModel employesModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 500),
                fit: BoxFit.cover,
                width: 200,
                height: 200,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                imageUrl: employesModel.imageUrl,
              ),
            ),
            Text(
              employesModel.fName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: employesModel.services.length,
                itemBuilder: (context, index) {
                  var service = employesModel.services[index];
                  log(employesModel.imageUrls.length.toString());

                  String name = service['name'];
                  var price = service['price'];

                  return ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$ $price',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      employesModel.description,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employesModel.location,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employesModel.pNumber.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Text("Beroooooooooooooooo"),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: employesModel.imageUrls.length,
                itemBuilder: (context, index) {
                  String imagePath = employesModel.imageUrls[index];
                  log(employesModel.imageUrls.length.toString());

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("berooooooooooooooooooooo"),
                        CachedNetworkImage(
                          imageUrl: imagePath,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 5),
                        Text("Image $index"),
                      ],
                    ),
                  );
                },
              ),
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
                      : const Text("LogOut"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
