import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

import '../domain/employes_repo.dart';

class EmployesRepoImp extends EmployesRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to pick a single image from the gallery
  @override
  Future<Either<String, File>> pickImage(File? image) async {
    final ImagePicker picker = ImagePicker();
    try {
      // Pick image from the gallery
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path); // Convert to File type
        return Right(image); // Return the selected image
      } else {
        return const Left(
            "No image selected"); // Return error if no image is picked
      }
    } catch (e) {
      return Left(
          "Failed to pick image: $e"); // Handle any errors that occur during image picking
    }
  }

  // Future<File?> cropImage(File image) async {
  //   final croppedImage =
  //       await ImageCropper().cropImage(sourcePath: image.path, uiSettings: [
  //     AndroidUiSettings(
  //         toolbarTitle: "crop",
  //         toolbarColor: Colors.blue,
  //         toolbarWidgetColor: Colors.white,
  //         hideBottomControls: true,
  //         lockAspectRatio: true)
  //   ]);
  //   if (croppedImage != null) {
  //     return File(croppedImage.path);
  //   }
  //   return null;
  // }

  // Function to upload employee data along with their images to Firestore and Firebase Storage
  @override
  Future<Either<String, EmployeeModel>> setEmployeData(
      EmployeeModel emplyesModel) async {
    try {
      String? imageUrl;

      // رفع صورة الملف الشخصي
      if (emplyesModel.image != null) {
        final storageRef =
            _storage.ref().child('users"/${emplyesModel.id}/profile_image.jpg');
        final uploadTask = storageRef.putFile(emplyesModel.image!);
        final snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      imageUrl ??= ''; // إذا لم توجد صورة شخصية، تعيين قيمة فارغة.

      // رفع الصور الإضافية
      List<String> imageUrls = [];
      if (emplyesModel.images != null && emplyesModel.images!.isNotEmpty) {
        for (var imageFile in emplyesModel.imageUrls) {
          final storageRef = _storage.ref().child(
              'users{emplyesModel.id}/additional_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = storageRef.putFile(File(imageFile));
          final snapshot = await uploadTask;
          final url = await snapshot.ref.getDownloadURL();
          imageUrls.add(url);
        }
      }

      // تحديث النموذج مع روابط الصور
      final updatedModel = EmployeeModel(
        imageUrls: imageUrls,
        id: emplyesModel.id,
        imageUrl: imageUrl,
        fName: emplyesModel.fName,
        location: emplyesModel.location,
        pNumber: emplyesModel.pNumber,
        description: emplyesModel.description,
        services: emplyesModel.services,
      );

      // تحديث البيانات في Firestore
      await _firestore
          .collection("users")
          .doc(updatedModel.id)
          .update(updatedModel.toDoc());

      // تحديث حالة الملف الشخصي
      await _firestore.collection("users").doc(updatedModel.id).update({
        'isProfileComplete': true,
      });

      return Right(updatedModel); // إرجاع النموذج المحدّث
    } catch (e) {
      return Left(e.toString()); // معالجة الأخطاء
    }
  }
}
