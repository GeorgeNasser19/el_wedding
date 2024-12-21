import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';
import 'package:el_wedding/features/userView/domain/user_repo/user_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepoImpl extends UserRepo {
  final _firebase = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  @override
  Future<Either<String, UserModel>> setUserModel(UserModel userModel) async {
    try {
      String? imageUrl;

      if (userModel.image != null) {
        final storageRef =
            _storage.ref().child('users"/${userModel.id}/profile_image.jpg');
        final uploadTask = storageRef.putFile(userModel.image!);
        final snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      imageUrl ??= '';

      final updateDate = UserModel(
          id: userModel.id, imageUrl: imageUrl, fName: userModel.fName);

      await _firebase
          .collection("users")
          .doc(userModel.id)
          .update(userModel.toDoc());

      await _firebase.collection("users").doc(userModel.id).update({
        'isProfileComplete': true,
      });

      return Right(updateDate);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<EmployeeModel>>> fetchPhotographers() async {
    try {
      final query = await _firebase
          .collection("users")
          .where("role", isEqualTo: "photographer")
          .get();

      final List<EmployeeModel> photograhers = query.docs
          .map((doc) => EmployeeModel.fromDoc(doc.data())..id = doc.id)
          .toList();

      return Right(photograhers);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<EmployeeModel>>> fetchMakeUpArtists() async {
    try {
      final query = await _firebase
          .collection("users")
          .where("role", isEqualTo: "makeupArtist")
          .get();

      final List<EmployeeModel> makeupArtist = query.docs
          .map((doc) => EmployeeModel.fromDoc(doc.data())..id = doc.id)
          .toList();

      return Right(makeupArtist);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
