// ignore: depend_on_referenced_packages
import 'dart:developer';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/domain/usecase/employ_repo_usecase.dart';
import 'package:equatable/equatable.dart';

part 'employes_state.dart';

class EmployesCubit extends Cubit<EmployesState> {
  EmployesCubit(this.employRepoUsecase, this.sharedServicesUsecase)
      : super(EmployesInitial());

  final EmployRepoUsecase employRepoUsecase;
  final SharedServicesUsecase sharedServicesUsecase;

  @override
  void onChange(change) {
    super.onChange(change);
    log(change.toString());
  }

  Future<void> pickIamge(File? image) async {
    emit(PickedIamgeLoading());

    final result = await employRepoUsecase.pickImgae(image);

    result.fold((fail) => emit(PickedIamgeFailur(fail)),
        (image) => emit(PickedIamgeLoaded(image)));
  }

  Future<void> saveData(EmployeeModel emplyesModel) async {
    emit(SaveDataLoading());

    final result = await employRepoUsecase.saveData(emplyesModel);

    result.fold((fail) => emit(SaveDataFailur(fail)),
        (emplyesModel) => emit(SaveDataLoaded(emplyesModel)));
  }

  Future<void> fetchEmployeeModel(String userId) async {
    emit(SaveDataLoading());

    final result = await sharedServicesUsecase.fetchEmployeeModel(userId);

    result.fold((fail) => emit(SaveDataFailur(fail)),
        (emplyesModel) => emit(SaveDataLoaded(emplyesModel)));
  }
}
