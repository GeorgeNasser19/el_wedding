// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/features/userView/data/model/user_model.dart';
import 'package:el_wedding/features/userView/domain/usecase_user_view/usecase_user_view.dart';
import 'package:equatable/equatable.dart';

part 'user_view_state.dart';

class UserViewCubit extends Cubit<UserViewState> {
  UserViewCubit(this.usecaseUserView, this.servicesUsecase)
      : super(UserViewInitial());

  final UsecaseUserView usecaseUserView;
  final SharedServicesUsecase servicesUsecase;

  Future<void> fetchDate(String userID) async {
    emit(UserViewLoading());
    final result = await servicesUsecase.fetchUserModel(userID);

    result.fold((fail) => emit(UserViewFauilar(fail)),
        (load) => emit(UserViewLoaded(load)));
  }

  Future<void> setDate(UserModel usermodel) async {
    emit(SetDateLoading());
    final result = await usecaseUserView.setUserModel(usermodel);

    result.fold((fail) => emit(SetDateFauiler(fail)),
        (load) => emit(SetDateLoaded(load)));
  }
}
