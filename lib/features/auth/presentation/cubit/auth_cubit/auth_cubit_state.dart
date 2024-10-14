part of 'auth_cubit_cubit.dart';

sealed class AuthCubitState extends Equatable {
  const AuthCubitState();

  @override
  List<Object> get props => [];
}

final class LoginCubitInitial extends AuthCubitState {}

final class LoginCubitLoading extends AuthCubitState {}

final class LoginCubitLoaded extends AuthCubitState {
  final UserModel user;

  const LoginCubitLoaded(this.user);
}

final class LoginCubitFauilar extends AuthCubitState {
  final String message;

  const LoginCubitFauilar(this.message);
}

final class RegisterCubitInitial extends AuthCubitState {}

final class RegisterCubitLoading extends AuthCubitState {}

final class RegisterCubitLoaded extends AuthCubitState {
  final UserModel user;

  const RegisterCubitLoaded(this.user);
}

final class RegisterCubitFauilar extends AuthCubitState {
  final String message;

  const RegisterCubitFauilar(this.message);
}
