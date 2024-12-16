import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/edit_image_profile.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/input_field_edit.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/muilt_pick_pic.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/services_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeEditProfile extends StatefulWidget {
  const EmployeeEditProfile({super.key, required this.employeeModel});
  final EmployeeModel employeeModel;
  @override
  State<EmployeeEditProfile> createState() => _EmployeeEditProfileState();
}

class _EmployeeEditProfileState extends State<EmployeeEditProfile> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController fname;
  late final TextEditingController description;
  late final TextEditingController location;
  late final TextEditingController pNumber;

  @override
  void initState() {
    fname = TextEditingController(text: widget.employeeModel.fName);
    description = TextEditingController(text: widget.employeeModel.description);
    location = TextEditingController(text: widget.employeeModel.location);
    pNumber =
        TextEditingController(text: widget.employeeModel.pNumber.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    EditImageProfile(image: widget.employeeModel.imageUrl),
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
                        services: widget.employeeModel.services,
                        onChange: () {
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MultiImagePickerWidget(
                      initialSelectedImages: widget.employeeModel.imageUrls
                          .map((path) => XFile(path))
                          .toList(), // تحويل List<String> إلى List<XFile>
                      onImagePicked: (pickedImages) {
                        setState(() {
                          widget.employeeModel.imageUrls
                              .addAll(pickedImages!.map((image) => image));
                        });
                      },
                    )
                  ],
                )),
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