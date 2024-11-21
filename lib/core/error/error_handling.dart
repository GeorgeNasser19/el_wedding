import 'package:firebase_auth/firebase_auth.dart';

String mapFirebaseAuthExceptionMessage(FirebaseAuthException e) {
  switch (e.code) {
    // login hundle error
    case "invalid-email":
      return "the email address is badly formatted.";
    case "user-not-found":
      return "No user is found with this email";
    case "wrong-password":
      return "incorrect password";
    case "network-reqest-failed":
      return "Netowrk error . please cheak your connection";

    // register hundle error
    case "email-already-in-use":
      return "The email address is already in use by another account.";
    case "weak-password":
      return "The password provided is too weak.";
    case "operation-not-allowed":
      return "Email/password accounts are not enabled. Please enable them in the Firebase console.";
    case "invalid-credential":
      return "Password or Email are invalid.";
    default:
      return "An unexpected error occurred. Please try again.";
  }
}
