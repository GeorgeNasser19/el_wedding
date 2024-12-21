import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/auth_model.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';

abstract class SharedServicesRepo {
  Future<Either<String, AuthModel>> fetchAuthModel(String uid);

  Future<Either<String, EmployeeModel>> fetchEmployeeModel(String uid);

  Future<Either<String, UserModel>> fetchUserModel(String uid);
}
