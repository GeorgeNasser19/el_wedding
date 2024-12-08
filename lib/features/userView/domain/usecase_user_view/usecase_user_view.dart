import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/userView/domain/user_repo/user_repo.dart';

class UsecaseUserView {
  final UserRepo userRepo;

  UsecaseUserView(this.userRepo);

  Future<Either<String, UserModel>> fetchUserModel(String userId) async {
    return await userRepo.getUserModel(userId);
  }
}
