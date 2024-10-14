import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/error/auth_error.dart';

class AuthRepoImp extends AuthRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepoImp({required this.firebaseAuth, required this.firestore});

  @override
  Future<Either<String, UserModel>> login(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return Right(UserModel(
            id: userCredential.user!.uid,
            name: userData["name"],
            email: email,
            role: userData["role"]));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(const UserNotFoundFailure() as String);
      } else if (e.code == 'wrong-password') {
        return Left(const WrongPasswordFailure() as String);
      } else if (e.code == 'invalid-email') {
        return Left(const InvalidEmailFailure() as String);
      } else {
        return Left(const UnknownAuthFailure() as String);
      }
    }

    return const Left('User document does not exist');
  }

  @override
  Future<Either<String, UserModel>> register(
      String name, String email, String password, UserRole role) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await firestore
          .collection("users")
          .doc(userCredential.user?.uid)
          .set({"name": name, "email": email, "role": role});

      return Right(UserModel(
          id: userCredential.user!.uid, name: name, email: email, role: role));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(const EmailAlreadyInUseFailure() as String);
      } else if (e.code == 'weak-password') {
        return Left(const WeakPasswordFailure() as String);
      } else {
        return Left(const UnknownAuthFailure() as String);
      }
    }
  }

  @override
  Future<void> logout() async {
    return await firebaseAuth.signOut();
  }
}
