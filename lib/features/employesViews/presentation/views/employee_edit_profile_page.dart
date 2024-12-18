import 'dart:developer';
import 'dart:io';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/button_set_employe_data.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/edit_image_profile.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/input_field_edit.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/multi_image_edit.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/services_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/scaffold_message.dart';
import '../employes_cubit/employes_cubit.dart';

class EmployeeEditProfile extends StatefulWidget {
  const EmployeeEditProfile({super.key, required this.employeeModel});
  final EmployeeModel employeeModel;
  @override
  State<EmployeeEditProfile> createState() => _EmployeeEditProfileState();
}

class _EmployeeEditProfileState extends State<EmployeeEditProfile> {
  final _formKey = GlobalKey<FormState>();

  late File? image;
  late List<String>? _selectedImages;
  late List<Map<String, dynamic>> services = [];

  late final TextEditingController fname;
  late final TextEditingController description;
  late final TextEditingController location;
  late final TextEditingController pNumber;

  // This method saves the employee's profile data to Firebase.

  @override
  void initState() {
    fname = TextEditingController(text: widget.employeeModel.fName);
    description = TextEditingController(text: widget.employeeModel.description);
    location = TextEditingController(text: widget.employeeModel.location);
    pNumber =
        TextEditingController(text: widget.employeeModel.pNumber.toString());

    image = File(widget.employeeModel.imageUrl);
    _selectedImages = List.from(widget.employeeModel.imageUrls);

    services = List.from(widget.employeeModel.services);

    super.initState();
  }

  void saveData() {
    // Getting the current user's ID from Firebase Authentication.
    String userId = FirebaseAuth.instance.currentUser!.uid;

    log(widget.employeeModel.imageUrl.toString());

    // Checking if an image is selected before saving the data.
    if (image == null) {
      // Show a message if no image is selected.
      ScaffoldMessageApp.snakeBar(context, "No Image profile Selected");
    }
    if (_selectedImages == null) {
      // Show a message if no image is selected.
      ScaffoldMessageApp.snakeBar(context, "No Images Selected");
    } else {
      // Saving the data using the EmployesCubit.
      context.read<EmployesCubit>().saveData(EmployeeModel(
            image: image!,
            description: description.text,
            fName: fname.text,
            location: location.text,
            pNumber: int.tryParse(pNumber.text) ?? 0,
            services: services,
            id: userId,
            images: _selectedImages!,
            imageUrls: _selectedImages!,
            imageUrl: image!.path,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
          ),
          backgroundColor: const Color.fromARGB(255, 245, 241, 241),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // pick image
                      EditImageProfile(image: image!.path),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFieldEdit(
                          username: widget.employeeModel.fName,
                          fname: fname,
                          description: description,
                          location: location,
                          pNumber: pNumber),
                      const SizedBox(
                        height: 10,
                      ),
                      ServicesInputWidget(
                          services: services,
                          onChange: (newservices) {
                            setState(() {
                              services = newservices;
                            });
                          }),
                      const SizedBox(
                        height: 10,
                      ),

                      MultiImageEdit(
                          initialImages: _selectedImages!
                              .map((path) => XFile(path))
                              .toList(),
                          onImagePicked: (updateImge) => setState(() {
                                _selectedImages = updateImge;
                              })),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonSetEmployeeData(
                          formKey: _formKey, saveData: saveData)
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
// context
//.read<EmployesCubit>()
//.pickIamge(File(widget
//.employeeModel.imageUrl));