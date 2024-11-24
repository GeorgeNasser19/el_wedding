import 'dart:io';

import 'package:dartz/dartz.dart';

import '../data/model/employes_model.dart';

abstract class EmployesRepo {
  Future<Either<String, EmployesModel>> setEmployeData(
      EmployesModel emplyesModel);

  Future<Either<String, File>> pickImage(File? image);

  Future<Either<String, EmployesModel>> getEmployeData(String uid);
}
