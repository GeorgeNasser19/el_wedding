import 'package:dartz/dartz.dart';
import 'package:el_wedding/core/shared_services/shared_services_repo/shared_services_repo.dart';

import '../../../features/auth/data/model/user_model.dart';
import '../../../features/employesViews/data/model/employes_model.dart';

class SharedServicesUsecase {
  final SharedServicesRepo sharedServicesRepo;

  SharedServicesUsecase(this.sharedServicesRepo);

  Future<Either<String, EmployeeModel>> fetchEmployeeModel(String uid) async {
    return await sharedServicesRepo.fetchEmployeeModel(uid);
  }

  Future<Either<String, UserModel>> fetchUserModel(String uid) async {
    return await sharedServicesRepo.fetchUserModel(uid);
  }
}
