import 'dart:io';

import 'package:el_wedding/core/scaffold_message.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/button_set_employe_data.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/multi_image_edit.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/pick_image_in_empolye_view.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/text_feilds_in_empolyes_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/employes_model.dart';
import '../employes_cubit/employes_cubit.dart';
import '../widgets/services_input.dart';

// This screen allows an employee to fill out their profile for the first time.
class EmpolyeProfileFirstEnter extends StatefulWidget {
  // Accepting the username as a parameter to show on the profile.
  final String userName;

  const EmpolyeProfileFirstEnter({super.key, required this.userName});

  @override
  // ignore: library_private_types_in_public_api
  _EmpolyeProfileFirstEnter createState() => _EmpolyeProfileFirstEnter();
}

class _EmpolyeProfileFirstEnter extends State<EmpolyeProfileFirstEnter> {
  // A global key to manage the state of the form.
  final _formKey = GlobalKey<FormState>();

  // Controllers to handle the text input fields.
  late final TextEditingController fname;
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController pNumber = TextEditingController();

  // A variable to hold the selected image.
  File? image;

  // A variable to hold the selected List of images for gallary Profile.
  List<String>? _selectedImages;

  // A list to manage services and their prices.
  List<Map<String, dynamic>> services = [
    {'name': '', 'price': 0.0} // Initial empty service entry.
  ];

  @override
  void initState() {
    fname = TextEditingController(text: widget.userName);
    super.initState();
  }

  // This method saves the employee's profile data to Firebase.
  void saveData() {
    // Getting the current user's ID from Firebase Authentication.
    String userId = FirebaseAuth.instance.currentUser!.uid;

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
            pNumber:
                int.tryParse(pNumber.text) ?? 0, // Default to 0 if invalid.
            services: services,
            id: userId, images: _selectedImages!, imageUrls: _selectedImages!,
            imageUrl: image!.path,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 241, 241),
        appBar: AppBar(
          backgroundColor: Colors.white,
          // Displaying the username in the app bar title.
          title: Text('Update Profile for ${widget.userName}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Wrapping the form in a scroll view for smaller screens.
            child: Form(
              key: _formKey, // Assigning the form key.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget for selecting an image.
                  PickImageInEmployeeView(
                    onImagePicked: (selectImage) {
                      image = selectImage; // Updating the selected image.
                    },
                  ),
                  const SizedBox(height: 15),
                  // Widget for input fields like name, description, etc.
                  TextFeildsInEmpolyesView(
                    userName: widget.userName,
                    fname: fname,
                    description: description,
                    location: location,
                    pNumber: pNumber,
                  ),
                  const SizedBox(height: 16), // Adding space.

                  // Displaying a list of service inputs dynamically.
                  ServicesInputWidget(
                    services: services,
                    onChange: (_) {
                      setState(() {});
                    },
                  ),

                  // Adding space.
                  const SizedBox(height: 16),
                  // Widget to select multiple images.
                  MultiImageEdit(
                    onImagePicked: (p0) => _selectedImages = p0,
                  ),
                  const SizedBox(height: 16),

                  // Button to save the profile data.
                  ButtonSetEmployeeData(formKey: _formKey, saveData: saveData)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
