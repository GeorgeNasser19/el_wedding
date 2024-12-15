part of 'select_role_cubit.dart';

sealed class SelectRoleState extends Equatable {
  const SelectRoleState();

  @override
  List<Object> get props => [];
}

final class SelectRoleInitial extends SelectRoleState {}

final class SelectRoleLoading extends SelectRoleState {}

final class SelectRoleLoaded extends SelectRoleState {}
