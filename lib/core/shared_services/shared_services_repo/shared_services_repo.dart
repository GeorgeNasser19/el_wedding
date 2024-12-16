import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';

abstract class SharedServicesRepo {
  Future<Either<String, UserModel>> fetchUserModel(String uid);

  Future<Either<String, EmployeeModel>> fetchEmployeeModel(String uid);
}
