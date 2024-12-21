import 'dart:io';

import 'package:el_wedding/features/userView/data/model/user_model.dart';
import 'package:el_wedding/features/userView/presentation/cubit/user_view_cubit.dart';
import 'package:el_wedding/features/userView/presentation/widgets/button_set_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/input_feild_with_text.dart';
import '../../../../core/scaffold_message.dart';
import '../../../../core/validation.dart';
import '../../../employesViews/presentation/widgets/pick_image_in_empolye_view.dart';

class UserEnterProfile extends StatefulWidget {
  const UserEnterProfile({super.key, required this.username});

  final String username;

  @override
  State<UserEnterProfile> createState() => _UserEnterProfileState();
}

class _UserEnterProfileState extends State<UserEnterProfile> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController fname;
  File? image;
  @override
  void initState() {
    fname = TextEditingController(text: widget.username);
    super.initState();
  }

  void saveData() {
    // Getting the current user's ID from Firebase Authentication.
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Checking if an image is selected before saving the data.
    if (image == null) {
      // Show a message if no image is selected.
      ScaffoldMessageApp.snakeBar(context, "No Image profile Selected");
    } else {
      // Saving the data using the EmployesCubit.
      context.read<UserViewCubit>().setDate(
          UserModel(id: userId, imageUrl: image!.path, fName: fname.text));
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
          title: Text('Update Profile for ${widget.username}'),
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
                      onImagePicked: (selectImage) {
                        image = selectImage; // Updating the selected image.
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          buildTextField(
                              design: true,
                              "Full Name",
                              widget.username,
                              fname,
                              ValidationApp.validateProfileSetup),
                          ButtonSetDate(formKey: _formKey, saveData: saveData)
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
