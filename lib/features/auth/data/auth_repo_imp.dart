import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
            role: userData["role"],
            password: userData["password"]));
      }
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseLoginExceptionMessage(e));
    } catch (e) {
      return left("please try again");
    }

    return const Left('User document does not exist');
  }

  @override
  Future<Either<String, UserModel>> register(
      String name, String email, String password, String role) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await firestore.collection("users").doc(userCredential.user?.uid).set(
          {"name": name, "email": email, "role": role, "password": password});

      return Right(UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          role: role,
          password: password));
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return left(_mapFirebaseRegisterExceptionMessage(e));
    } catch (e) {
      return left("please try again");
    }
  }

  @override
  Future<Either<String, UserModel>> signWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return const Left("Failed to sign in with Google.");
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        return const Left("Failed to authenticate Google user.");
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return const Left("Failed to sign in with credentials.");
      }

      // فحص ما إذا كان المستخدم موجودًا في Firestore
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        // المستخدم جديد، قم بتخزين بياناته وتوجيهه لاختيار دوره
        await firestore.collection("users").doc(userCredential.user?.uid).set({
          "name": googleUser.displayName,
          "email": googleUser.email,
          "role": null,
          "password": null // لا نقوم بتحديد الدور بعد
        });

        // إرجاع حالة new_user
        return const Left("new_user");
      } else {
        // التحقق من أن البيانات المسترجعة ليست null
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData == null || !userData.containsKey('role')) {
          return const Left("User data is invalid or missing.");
        }

        // المستخدم موجود، استرجاع البيانات من Firestore
        UserModel user = UserModel(
          id: userCredential.user!.uid,
          name: googleUser.displayName!,
          email: googleUser.email,
          role: (userData["role"]),
          password: userData["password"],
        );

        // إرجاع حالة loaded
        return Right(user);
      }
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseRegisterExceptionMessage(e));
    } catch (e) {
      return const Left("An unknown error occurred. Please try again.");
    }
  }

  @override
  Future<Either<String, void>> forgetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null); // إرجاع نتيجة صحيحة دون بيانات
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseForgotPasswordExceptionMessage(e));
    } catch (e) {
      return left("An unknown error occurred. Please try again.");
    }
  }

  @override
  Future<void> logout() async {
    return await firebaseAuth.signOut();
  }
}

String _mapFirebaseLoginExceptionMessage(FirebaseAuthException e) {
  switch (e.code) {
    case "invalid-email":
      return "The email address is badly formatted.";
    case "user-not-found":
      return "No user is found with this email.";
    case "wrong-password":
      return "Incorrect password.";
    case "network-request-failed":
      return "Network error. Please check your connection.";
    default:
      return "An unexpected error occurred during login. Please try again.";
  }
}

String _mapFirebaseRegisterExceptionMessage(FirebaseAuthException e) {
  switch (e.code) {
    case "email-already-in-use":
      return "The email address is already in use by another account.";
    case "weak-password":
      return "The password provided is too weak.";
    case "operation-not-allowed":
      return "Email/password accounts are not enabled. Please enable them in the Firebase console.";
    case "invalid-credential":
      return "Password or Email are invalid.";
    case "invalid-email":
      return "The email address is badly formatted.";
    case "too-many-requests":
      return "Too many requests. Please try again later.";
    case "credential-already-in-use":
      return "This credential is already associated with a different user account.";
    case "user-disabled":
      return "This user account has been disabled by an administrator.";
    case "invalid-verification-code":
      return "The verification code entered is invalid.";
    case "invalid-verification-id":
      return "The verification ID is invalid or expired.";
    default:
      return "An unexpected error occurred during registration. Please try again.";
  }
}

String _mapFirebaseForgotPasswordExceptionMessage(FirebaseAuthException e) {
  switch (e.code) {
    case "invalid-email":
      return "The email address is badly formatted.";
    case "user-not-found":
      return "No user is found with this email.";
    default:
      return "An unexpected error occurred during password reset. Please try again.";
  }
}
