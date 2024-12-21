import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/userView/domain/user_repo/user_repo.dart';

import '../../data/model/user_model.dart';

class UsecaseUserView {
  final UserRepo userRepo;

  UsecaseUserView(this.userRepo);

  Future<Either<String, UserModel>> setUserModel(UserModel userModel) async {
    return await userRepo.setUserModel(userModel);
  }
}
