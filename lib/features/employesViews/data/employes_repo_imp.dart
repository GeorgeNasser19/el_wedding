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

  @override
  Future<Either<String, File>> pickImage(File? image) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image = File(pickedFile.path);
        return Right(image);
      } else {
        return const Left("No image selected");
      }
    } catch (e) {
      return Left("Failed to pick image: $e");
    }
  }

  @override
  Future<Either<String, EmployesModel>> setEmployeData(
      EmployesModel emplyesModel) async {
    try {
      // 1. رفع الصورة إلى Firebase Storage
      String? imageUrl;
      if (emplyesModel.image != null) {
        final storageRef =
            _storage.ref().child('users/${emplyesModel.id}/profile_image.jpg');
        final uploadTask = storageRef.putFile(emplyesModel.image!);
        final snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // 2. إنشاء نسخة محدثة من النموذج
      final updatedModel = EmployesModel(
        id: emplyesModel.id,
        imageUrl: imageUrl, // رابط الصورة المحفوظ
        image: emplyesModel.image, // إلغاء استخدام الصورة نفسها بعد رفعها
        fName: emplyesModel.fName,
        location: emplyesModel.location,
        pNumber: emplyesModel.pNumber,
        description: emplyesModel.description,
        services: emplyesModel.services,
      );

      // 3. حفظ البيانات في Firestore
      await _firestore
          .collection("users")
          .doc(updatedModel.id)
          .update(updatedModel.toDoc());

      return Right(updatedModel); // إرجاع النتيجة بنجاح
    } catch (e) {
      return Left(e.toString()); // إرجاع الخطأ إذا حدث
    }
  }

  @override
  Future<Either<String, EmployesModel>> getEmployeData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return right(EmployesModel.fromDoc(doc.data() as Map<String, dynamic>));
      } else {
        return left("No employee data found for userId:");
      }
    } catch (e) {
      return left("Error fetching employee data: ${e.toString()}");
    }
  }
}
