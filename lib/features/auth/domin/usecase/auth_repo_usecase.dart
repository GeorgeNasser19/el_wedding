import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repo.dart';

class AuthRepoUsecase {
  final AuthRepo authRepo;

  AuthRepoUsecase(this.authRepo);

  Future<Either<String, void>> login(
    String email,
    String password,
  ) async {
    return await authRepo.login(
      email,
      password,
    );
  }

  Future<Either<String, void>> register(
    String email,
    String password,
    String name,
  ) async {
    return await authRepo.register(email, password, name);
  }

  Future<void> logout() {
    return authRepo.logout();
  }

  Future<Either<String, void>> signWithGoogle() async {
    return await authRepo.signWithGoogle();
  }

  Future<Either<String, void>> forgetPassword(String email) async {
    return await authRepo.forgetPassword(email);
  }

  Future<User?> getUser() async {
    return await authRepo.getCurrentUser();
  }

  Stream<User?> changeState() {
    return authRepo.changeState();
  }

  Future<Either<String, void>> setData(
    String role,
  ) async {
    return await authRepo.setDate(role);
  }

  Future<bool> checkIfRoleIsNotSelected(String userId) async {
    return await authRepo.checkIfRoleIsNotSelected(userId);
  }
}
