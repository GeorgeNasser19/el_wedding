import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/features/auth/data/model/auth_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';
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

    final authModelMap = await sharedServicesUsecase.fetchAuthModel(user.uid);
    AuthModel? authModel;
    authModelMap.fold(
        (left) => "failed to fetch user", (authDate) => authModel = authDate);

    if (isRoleSelected == true && authModel!.role == 'makeupArtist' ||
        authModel!.role == 'photographer' &&
            authModel!.isProfileComplete == false) {
      emit(NoProfileComolete(authModel!.name));
      return;
    }

    final employeeModelMap =
        await sharedServicesUsecase.fetchEmployeeModel(user.uid);
    EmployeeModel? employeeModel;
    employeeModelMap.fold((fail) => "failed to fetch employee",
        (employeeDate) => employeeModel = employeeDate);

    final userModelMap = await sharedServicesUsecase.fetchUserModel(user.uid);
    UserModel? userModel;
    userModelMap.fold((fail) => "failed to fetch employee",
        (userDate) => userModel = userDate);

    if (authModel!.role == "user" && authModel!.isProfileComplete == true) {
      emit(UserLoaded(userModel!));
      return;
    }
    if (isRoleSelected == true &&
        authModel!.role == "user" &&
        authModel!.isProfileComplete == false) {
      emit(UserFirstEnter(authModel!.name));
      return;
    }
    if (authModel!.role == 'makeupArtist' ||
        authModel!.role == 'photographer' &&
            authModel!.isProfileComplete == true) {
      emit(ProfileComplete(employeeModel!));
      return;
    }
  }
}
