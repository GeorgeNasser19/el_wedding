import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:equatable/equatable.dart';

part 'check_auth_state.dart';

class CheckAuthCubit extends Cubit<CheckAuthState> {
  CheckAuthCubit(this.authRepoUsecase, this.sharedServicesUsecase)
      : super(CheckAuthInitial());

  final SharedServicesUsecase sharedServicesUsecase;
  final AuthRepoUsecase authRepoUsecase;

  @override
  void onChange(change) {
    super.onChange(change);
    log(change.toString());
  }

  Future<void> checkAuth() async {
    authRepoUsecase.changeState();

    emit(CheckAuthLoading());

    final user = await authRepoUsecase.getUser();
    log(user.toString());

    if (user == null) {
      emit(NoUser());
      return;
    }

    final isRoleSelected =
        await authRepoUsecase.checkIfRoleIsNotSelected(user.uid);

    if (isRoleSelected == false) {
      emit(NoSelectedRole());
      return;
    }

    final userModelMap = await sharedServicesUsecase.fetchUserModel(user.uid);
    UserModel? userModel;
    userModelMap.fold(
        (left) => "failed to fetch user", (userDate) => userModel = userDate);

    if (isRoleSelected == true && userModel!.isProfileComplete == false) {
      emit(NoProfileComolete(userModel!.name));
      return;
    }

    final employeeModelMap =
        await sharedServicesUsecase.fetchEmployeeModel(user.uid);
    EmployeeModel? employeeModel;
    employeeModelMap.fold((fail) => "failed to fetch employee",
        (employeeDate) => employeeModel = employeeDate);

    if (userModel!.role == "user") {
      emit(UserLoaded(userModel!, employeeModel!));
      return;
    }
    if (userModel!.role == "user" && userModel!.isProfileComplete == false) {
      // TODO :
    }
    if (userModel!.role == 'makeupArtist' ||
        userModel!.role == 'photographer' &&
            userModel!.isProfileComplete == true) {
      emit(ProfileComplete(employeeModel!));
      return;
    }
  }
}
