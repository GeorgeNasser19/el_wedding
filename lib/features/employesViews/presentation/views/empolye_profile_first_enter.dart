import 'dart:io';

import 'package:el_wedding/core/scaffold_message.dart';
import 'package:el_wedding/features/auth/presentation/widgets/divider_with_or_text.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/pick_image_in_empolye_view.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/text_feilds_in_empolyes_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/employes_model.dart';
import '../employes_cubit/employes_cubit.dart';

class EmpolyeProfileFirstEnter extends StatefulWidget {
  final String userName;

  const EmpolyeProfileFirstEnter({super.key, required this.userName});

  @override
  // ignore: library_private_types_in_public_api
  _MakeUpArtistView createState() => _MakeUpArtistView();
}

class _MakeUpArtistView extends State<EmpolyeProfileFirstEnter> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fname = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController pNumber = TextEditingController();

  File? image;
  List<Map<String, dynamic>> services = [
    {'name': '', 'price': 0.0}
  ];

  // الحصول على ID المستخدم الحالي
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Widget buildServiceInput(int index) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => services[index]['name'] = value,
            decoration: const InputDecoration(labelText: 'Service Name'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            onChanged: (value) =>
                services[index]['price'] = double.tryParse(value) ?? 0.0,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            services.removeAt(index);
            setState(() {});
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile for ${widget.userName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PickImageInEmployeeView(
                  onImagePicked: (image3) {
                    image = image3;
                  },
                ),
                TextFeildsInEmpolyesView(
                  userName: widget.userName,
                  fname: fname,
                  description: description,
                  location: location,
                  pNumber: pNumber,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Services and Prices',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: services.asMap().entries.map((entry) {
                    int index = entry.key;
                    return buildServiceInput(index);
                  }).toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Service'),
                  onPressed: () {
                    services.add({'name': '', 'price': 0.0});
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                const DividerWithOrText(
                  text: 'Or',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (image == null) {
                            ScaffoldMessageApp.snakeBar(
                                context, "No Image Selected");
                          } else {
                            context
                                .read<EmployesCubit>()
                                .saveData(EmployesModel(
                                  image: image!,
                                  description: description.text,
                                  fName: fname.text,
                                  location: location.text,
                                  pNumber: int.tryParse(pNumber.text) ?? 0,
                                  services: services,
                                  id: userId, // استخدام userId هنا
                                ));
                          }
                        },
                        child: const Text('Save'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
