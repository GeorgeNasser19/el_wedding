import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Stream<User?> changeState();

  Future<Either<String, void>> login(
    String email,
    String password,
  );
  Future<Either<String, void>> register(
      String email, String password, String name);
  Future<Either<String, void>> signWithGoogle();

  Future<Either<String, void>> setDate(String role);

  Future<Either<String, void>> forgetPassword(String email);

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<bool> checkIfRoleIsNotSelected(String userId);
}
