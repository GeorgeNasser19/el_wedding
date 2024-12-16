part of 'check_auth_cubit.dart';

sealed class CheckAuthState extends Equatable {
  const CheckAuthState();

  @override
  List<Object> get props => [];
}

final class CheckAuthInitial extends CheckAuthState {}

final class CheckAuthLoading extends CheckAuthState {}

final class NoUser extends CheckAuthState {}

final class NoSelectedRole extends CheckAuthState {}

final class NoProfileComolete extends CheckAuthState {
  final String username;
  const NoProfileComolete(this.username);
  @override
  List<Object> get props => [username];
}

final class ProfileComplete extends CheckAuthState {
  final EmployeeModel employeeModel;

  const ProfileComplete(this.employeeModel);
  @override
  List<Object> get props => [employeeModel];
}

final class UserLoaded extends CheckAuthState {
  final UserModel userModel;

  const UserLoaded(this.userModel);
  @override
  List<Object> get props => [userModel];
}
