import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';

abstract class UserRepo {
  Future<Either<String, UserModel>> getUserModel(String userId);
}
