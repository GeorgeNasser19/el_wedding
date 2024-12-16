import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/error/error_handling.dart';
import '../domin/usecase/auth_repo.dart';

class AuthRepoImp extends AuthRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRepoImp(
      {required this.googleSignIn,
      required this.firebaseAuth,
      required this.firestore});

  /// تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  @override
  Future<Either<String, void>> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      log("Firebase Login Error: ${e.message}");
      return Left(ErrorHandling.mapFirebaseLoginExceptionMessage(e));
    } catch (e) {
      log("Unexpected Login Error: $e");
      return const Left("An unexpected error occurred. Please try again.");
    }
  }

  /// تسجيل مستخدم جديد باستخدام البريد الإلكتروني وكلمة المرور
  @override
  Future<Either<String, void>> register(
      String email, String password, String name) async {
    try {
      // إنشاء مستخدم جديد في Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // الحصول على معرف المستخدم UID
      final userId = userCredential.user?.uid;

      if (userId == null) {
        return const Left("Failed to retrieve user ID after registration.");
      }

      final userDocRef = firestore.collection("users").doc(userId);

      // التحقق مما إذا كان المستند موجودًا
      final docSnapshot = await userDocRef.get();
      if (!docSnapshot.exists) {
        // إذا لم يكن موجودًا، قم بإنشائه
        await userDocRef.set({
          "email": email,
          "name": name,
          "isSelectedRole": false,
          "isProfileComplete": false // تعيين القيمة الافتراضية
        });
      } else {
        // إذا كان موجودًا، قم بتحديث البيانات فقط
        await userDocRef.update({"email": email, "name": name});
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      log("Firebase Register Error: ${e.message}");
      return Left(ErrorHandling.mapFirebaseRegisterExceptionMessage(e));
    } catch (e) {
      log("Unexpected Register Error: $e");
      return const Left("An unexpected error occurred. Please try again.");
    }
  }

  /// تسجيل الدخول باستخدام Google
  @override
  Future<Either<String, void>> signWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return const Left("تم إلغاء تسجيل الدخول باستخدام Google.");
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return const Left(
            "فشل في الحصول على بيانات المستخدم بعد تسجيل الدخول.");
      }

      final userDocRef = firestore.collection("users").doc(user.uid);

      // التحقق مما إذا كان المستند موجودًا
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        firestore.collection("users").doc(user.uid).get();
      } else {
        await userDocRef.set({
          "email": user.email,
          "name": user.displayName,
          "isSelectedRole": false,
          "isProfileComplete": false // تعيين القيمة الافتراضية
        });
      }

      return const Right(null);
    } catch (e) {
      log("Google Sign-in Error: $e");
      return const Left(
          "حدث خطأ أثناء تسجيل الدخول باستخدام Google. يرجى المحاولة مرة أخرى.");
    }
  }

  /// إعادة تعيين كلمة المرور
  @override
  Future<Either<String, void>> forgetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      log("Firebase Reset Password Error: ${e.message}");
      return Left(ErrorHandling.mapFirebaseForgotPasswordExceptionMessage(e));
    } catch (e) {
      log("Unexpected Password Reset Error: $e");
      return const Left("An unexpected error occurred. Please try again.");
    }
  }

  /// تسجيل الخروج
  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
      // await googleSignIn.disconnect();
    } catch (e) {
      log("Logout Error: $e");
    }
  }

  /// الحصول على المستخدم الحالي
  @override
  Future<User?> getCurrentUser() async {
    try {
      return firebaseAuth.currentUser;
    } catch (e) {
      log("Error fetching current user: $e");
      return null;
    }
  }

  /// مراقبة حالة المستخدم (Logged In / Logged Out)
  @override
  Stream<User?> changeState() {
    return firebaseAuth.authStateChanges();
  }

  /// إضافة بيانات المستخدم إلى Firestore
  @override
  Future<Either<String, void>> setDate(String role) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;

      if (userId == null) {
        return const Left("No user is currently logged in.");
      }

      await firestore.collection("users").doc(userId).update({
        "role": role,
        "isSelectedRole": true,
      });
      await firestore
          .collection("users")
          .doc(userId)
          .update({"isSelectedRole": true});

      return const Right(null);
    } catch (e) {
      log("Error setting user data: $e");
      return const Left("Failed to save user data. Please try again.");
    }
  }

  @override
  Future<bool> checkIfRoleIsNotSelected(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        {
          return data?['isSelectedRole']; // تأكد من تطابق النوع
        }
      }
    } catch (e) {
      log("Error checking isSelectedRole: $e");
    }
    return true;
  }
}
