import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// This class implements authentication functionalities based on the AuthRepo contract
class AuthRepoImp extends AuthRepo {
  final FirebaseAuth firebaseAuth; // FirebaseAuth instance for authentication
  final FirebaseFirestore
      firestore; // Firestore instance for database operations

  AuthRepoImp({required this.firebaseAuth, required this.firestore});

  // Login function with email and password
  @override
  Future<Either<String, UserModel>> login(String email, String password) async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Retrieve user data from Firestore based on the user's unique ID
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      // Check if user document exists in Firestore
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return Right(UserModel(
          id: userCredential.user!.uid,
          name: userData["name"],
          email: email,
          role: userData["role"],
        ));
      }
    } on FirebaseAuthException catch (e) {
      return left(
          _mapFirebaseLoginExceptionMessage(e)); // Map specific error messages
    } catch (e) {
      return left("please try again"); // Handle unexpected errors
    }

    return const Left(
        'User document does not exist'); // Return if user doc is missing
  }

  // Register function for creating new user with email, password, name, and role
  @override
  Future<Either<String, UserModel>> register(
      String name, String email, String password, String role) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user data in Firestore
      await firestore.collection("users").doc(userCredential.user?.uid).set(
          {"name": name, "email": email, "role": role, "password": password});

      return Right(UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        role: role,
      ));
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return left(_mapFirebaseRegisterExceptionMessage(
          e)); // Map specific error messages
    } catch (e) {
      return left("please try again"); // Handle unexpected errors
    }
  }

  // Google sign-in function
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

      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        // New user, store initial data with role and password as null
        await firestore.collection("users").doc(userCredential.user?.uid).set({
          "name": googleUser.displayName,
          "email": googleUser.email,
          "role": null,
        });

        return const Left("new_user"); // Indicate new user status
      } else {
        // Existing user, retrieve data from Firestore
        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData == null || !userData.containsKey('role')) {
          return const Left("User data is invalid or missing.");
        }

        // Construct UserModel from Firestore data
        UserModel user = UserModel(
          id: userCredential.user!.uid,
          name: googleUser.displayName!,
          email: googleUser.email,
          role: (userData["role"]),
        );

        return Right(user); // Indicate loaded status
      }
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseRegisterExceptionMessage(e));
    } catch (e) {
      return const Left("An unknown error occurred. Please try again.");
    }
  }

  // Function to handle password reset
  @override
  Future<Either<String, void>> forgetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null); // Successfully sent reset email
    } on FirebaseAuthException catch (e) {
      return left(_mapFirebaseForgotPasswordExceptionMessage(
          e)); // Map specific error messages
    } catch (e) {
      return left("An unknown error occurred. Please try again.");
    }
  }

  // Logout function
  @override
  Future<void> logout() async {
    return await firebaseAuth.signOut();
  }
}

// Helper function to map Firebase exceptions during login
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

// Helper function to map Firebase exceptions during registration
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

// Helper function to map Firebase exceptions during password reset
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
