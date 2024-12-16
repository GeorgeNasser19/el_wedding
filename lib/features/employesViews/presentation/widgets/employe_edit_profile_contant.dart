import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class EmployeEditProfileContant extends StatelessWidget {
  const EmployeEditProfileContant({super.key, required this.employesModel});

  final EmployeeModel employesModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              // employee image
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 24),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: employesModel.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // employee full name
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Text(employesModel.fName,
                    style: const TextStyle(fontSize: 20)),
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
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                context.push("/EmployeeEditProfile", extra: employesModel);
              },
              icon: const Icon(Icons.edit),
            ),
          ],
          backgroundColor: Colors.white,
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // image and full name and description for employee
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        fadeInDuration: const Duration(milliseconds: 500),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageUrl: employesModel.imageUrl,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employesModel.fName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 260,
                          child: Text(
                            maxLines: 3,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            employesModel.description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                // phone number for employee
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phone Number",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        employesModel.pNumber.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                // location number for employee
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        employesModel.location,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                // services for employee
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Services",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: employesModel.services.length,
                      itemBuilder: (context, index) {
                        var service = employesModel.services[index];
                        String name = service['name'];
                        var price = service['price'];

                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${price.toString()} E.L",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                // Galary
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Galary",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: employesModel.imageUrls.length,
                      itemBuilder: (context, index) {
                        String imagePath = employesModel.imageUrls[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: imagePath,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
