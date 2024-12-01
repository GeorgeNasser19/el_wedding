import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class ErrorHandling {
  // Helper function to map Firebase exceptions during login
  static String mapFirebaseLoginExceptionMessage(FirebaseAuthException e) {
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
  static String mapFirebaseRegisterExceptionMessage(FirebaseAuthException e) {
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
  static String mapFirebaseForgotPasswordExceptionMessage(
      FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "The email address is badly formatted.";
      case "user-not-found":
        return "No user is found with this email.";
      default:
        return "An unexpected error occurred during password reset. Please try again.";
    }
  }

  static String mapsetDataError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action.';
        case 'not-found':
          return 'Data not found.';
        case 'unavailable':
          return 'Service is currently unavailable. Please try again later.';
        default:
          return 'An unexpected error occurred: ${error.message}';
      }
    } else if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }
}
