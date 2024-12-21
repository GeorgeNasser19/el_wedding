import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/core/shared_services/shared_services_repo/shared_services_repo.dart';
import 'package:el_wedding/features/auth/data/model/auth_model.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';

class SharedServicesRepoImpl extends SharedServicesRepo {
  final firebase = FirebaseFirestore.instance;

  @override
  Future<Either<String, EmployeeModel>> fetchEmployeeModel(String uid) async {
    try {
      final doc = await firebase.collection("users").doc(uid).get();

      if (doc.exists) {
        return Right(EmployeeModel.fromDoc(doc.data()!));
      }
    } catch (e) {
      return Left(e.toString());
    }
    return const Left("User not found");
  }

  @override
  Future<Either<String, AuthModel>> fetchAuthModel(String uid) async {
    try {
      final doc = await firebase.collection("users").doc(uid).get();

      if (doc.exists) {
        return Right(AuthModel.fromDoc(doc.data()!));
      }
    } catch (e) {
      return Left(e.toString());
    }
    return const Left("User not found");
  }

  @override
  Future<Either<String, UserModel>> fetchUserModel(String uid) async {
    try {
      final doc = await firebase.collection("users").doc(uid).get();

      if (doc.exists) {
        return Right(UserModel.fromDoc(doc.data()!));
      }
    } catch (e) {
      return Left(e.toString());
    }
    return const Left("User not found");
  }
}
