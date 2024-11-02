import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';

abstract class AuthRepo {
  Future<Either<String, UserModel>> login(String email, String password);
  Future<Either<String, UserModel>> register(
      String name, String email, String password, String role);
  Future<Either<String, UserModel>> signWithGoogle();

  Future<Either<String, void>> forgetPassword(String email);

  Future<void> logout();
}
