import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/userView/domain/user_repo/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final firebase = FirebaseFirestore.instance;

  @override
  Future<Either<String, UserModel>> getUserModel(String userId) async {
    try {
      final doc = await firebase.collection("users").doc(userId).get();

      if (doc.exists) {
        return Right(UserModel.fromDoc(doc.data()!));
      }
    } catch (e) {
      return Left(e.toString());
    }
    return const Left("User not found");
  }
}
