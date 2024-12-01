import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/error_handling.dart';
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

  // Function to upload employee data along with their images to Firestore and Firebase Storage
  @override
  Future<Either<String, EmployesModel>> setEmployeData(
      EmployesModel emplyesModel) async {
    try {
      String? imageUrl;

      // 1. Upload profile image to Firebase Storage
      if (emplyesModel.image != null) {
        final storageRef =
            _storage.ref().child('users/${emplyesModel.id}/profile_image.jpg');
        final uploadTask = storageRef.putFile(emplyesModel.image!);
        final snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL(); // Get the download URL
      }

      List<String> imageUrls = []; // List to store URLs of additional images

      // 2. Upload additional images to Firebase Storage
      for (var imageFile in emplyesModel.images) {
        final storageRef = _storage.ref().child(
            'users/${emplyesModel.id}/additional_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask =
            storageRef.putFile(File(imageFile)); // Upload image file
        final snapshot = await uploadTask;
        final imageUrl =
            await snapshot.ref.getDownloadURL(); // Get download URL
        imageUrls.add(imageUrl); // Add image URL to list
      }

      // 3. Create an updated model with the new image URLs
      final updatedModel = EmployesModel(
        id: emplyesModel.id,
        imageUrl: imageUrl!,
        image: emplyesModel.image,
        fName: emplyesModel.fName,
        location: emplyesModel.location,
        pNumber: emplyesModel.pNumber,
        description: emplyesModel.description,
        services: emplyesModel.services,
        images: emplyesModel.images,
      );

      // 4. Update the employee data in Firestore
      await _firestore
          .collection("users")
          .doc(updatedModel.id)
          .update(updatedModel.toDoc());

      // 5. Set the profile completion status to true
      await _firestore.collection("users").doc(updatedModel.id).update({
        'isProfileComplete': true,
      });

      return Right(
          updatedModel); // Return the updated model if everything is successful
    } on FirebaseAuthException catch (e) {
      return Left(ErrorHandling.mapsetDataError(
          e)); // Handle FirebaseAuthException errors
    } catch (e) {
      return Left(e.toString()); // Return any other errors that might occur
    }
  }

  // Function to fetch employee data from Firestore
  @override
  Future<Either<String, EmployesModel>> getEmployeData(String uid) async {
    try {
      // Get employee document from Firestore using the user ID
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      if (doc.exists && doc.data() != null) {
        // If document exists and data is not null, map it to EmployesModel
        return right(EmployesModel.fromDoc(doc.data() as Map<String, dynamic>));
      } else {
        return left(
            "No employee data found for userId: $uid"); // Return error if no data found
      }
    } catch (e) {
      return left(
          "Error fetching employee data: ${e.toString()}"); // Handle errors during data fetching
    }
  }
}
