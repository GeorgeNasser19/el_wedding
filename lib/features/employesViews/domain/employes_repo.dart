import 'dart:io';

import 'package:dartz/dartz.dart';

import '../data/model/employes_model.dart';

abstract class EmployesRepo {
  Future<Either<String, File>> pickImage(File? image);
  Future<Either<String, EmployeeModel>> setEmployeData(
      EmployeeModel emplyesModel);
  Future<Either<String, EmployeeModel>> getEmployeData(String userId);
}
