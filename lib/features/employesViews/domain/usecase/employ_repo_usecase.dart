import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';

import '../employes_repo.dart';

class EmployRepoUsecase {
  final EmployesRepo employesRepo;

  EmployRepoUsecase(this.employesRepo);

  Future<Either<String, EmployeeModel>> saveData(
      EmployeeModel emplyesModel) async {
    return await employesRepo.setEmployeData(emplyesModel);
  }

  Future<Either<String, File>> pickImgae(File? image) async {
    return await employesRepo.pickImage(image);
  }

  Future<Either<String, EmployeeModel>> fetchEmpoleeModel(String userID) async {
    return await employesRepo.getEmployeData(userID);
  }
}
