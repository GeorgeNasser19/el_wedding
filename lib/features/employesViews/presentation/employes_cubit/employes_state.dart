part of 'employes_cubit.dart';

sealed class EmployesState extends Equatable {
  const EmployesState();

  @override
  List<Object> get props => [];
}

final class EmployesInitial extends EmployesState {}

final class SaveDataLoading extends EmployesState {}

final class SaveDataLoaded extends EmployesState {
  final EmployesModel employesModel;

  const SaveDataLoaded(this.employesModel);

  @override
  List<Object> get props => [employesModel];
}

final class SaveDataFailur extends EmployesState {
  final String errorMessage;

  const SaveDataFailur(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class PickedIamgeLoading extends EmployesState {}

final class PickedIamgeLoaded extends EmployesState {
  final File image;

  const PickedIamgeLoaded(this.image);

  @override
  List<Object> get props => [image];
}

final class PickedIamgeFailur extends EmployesState {
  final String errorMessage;

  const PickedIamgeFailur(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
