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
            // Image.network(employesModel.imageUrl!),
            Text(employesModel.fName),
            // استخدام ListView لعرض الـ name والـ price لكل خدمة
            Expanded(
              child: ListView.builder(
                itemCount: employesModel.services.length,
                itemBuilder: (context, index) {
                  // استخراج الـ Map لكل خدمة
                  var service = employesModel.services[index];

                  // استخراج الـ name و الـ price من الـ Map
                  String name = service['name']; // القيمة التي تحمل اسم الخدمة
                  var price = service['price']; // القيمة التي تحمل السعر

                  return ListTile(
                    title: Text(
                      name, // عرض اسم الخدمة
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$ $price', // عرض السعر
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            Image.network(employesModel.imageUrl),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: employesModel.images.length,
            //     itemBuilder: (context, index) {
            //       String imagePath = employesModel.images[index];

            //       return Container(
            //         margin: EdgeInsets.symmetric(vertical: 5),
            //         child: Row(
            //           children: [
            //             Container(
            //               width: 50.0, // عرض الصورة
            //               height: 50.0, // ارتفاع الصورة
            //               child: Image.network(
            //                 imagePath, // تحميل الصورة من الرابط
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             SizedBox(width: 10), // المسافة بين الصورة والنص
            //             Text("Image $index"), // نص أو عنصر آخر
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
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
