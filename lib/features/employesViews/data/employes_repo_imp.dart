import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/employes_repo.dart';

class EmployesRepoImp extends EmployesRepo {
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
  Future<Either<String, EmployesModel>> saveData(
      EmployesModel emplyesModel) async {
    try {
      // 1. رفع الصورة إلى Firebase Storage
      String? imageUrl;
      if (emplyesModel.image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users/${emplyesModel.id}/profile_image.jpg');
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
      await FirebaseFirestore.instance
          .collection("users")
          .doc(updatedModel.id)
          .update(updatedModel.toDoc());

      return Right(updatedModel); // إرجاع النتيجة بنجاح
    } catch (e) {
      return Left(e.toString()); // إرجاع الخطأ إذا حدث
    }
  }
}
