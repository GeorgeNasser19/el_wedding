import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repo.dart';

class AuthRepoUsecase {
  final AuthRepo authRepo;

  AuthRepoUsecase(this.authRepo);

  Future<Either<String, UserModel>> login(String email, String password) async {
    return await authRepo.login(email, password);
  }

  Future<Either<String, UserModel>> register(
      String email, String password, String name, String role) async {
    return await authRepo.register(email, password, name, role);
  }

  Future<void> logout() {
    return authRepo.logout();
  }

  Future<Either<String, UserModel>> signWithGoogle() async {
    return await authRepo.signWithGoogle();
  }

  Future<Either<String, void>> forgetPassword(String email) async {
    return await authRepo.forgetPassword(email);
  }

  Future<String> getUserId() async {
    return await authRepo.getUserId();
  }

  Stream<User?> changeState() {
    return authRepo.changeState();
  }
}
