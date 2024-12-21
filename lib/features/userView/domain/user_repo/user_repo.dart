import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';

abstract class UserRepo {
  Future<Either<String, UserModel>> setUserModel(UserModel userModel);

  Future<Either<String, List<EmployeeModel>>> fetchPhotographers();

  Future<Either<String, List<EmployeeModel>>> fetchMakeUpArtists();
}
