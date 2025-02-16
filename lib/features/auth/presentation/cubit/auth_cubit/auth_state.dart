part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInit extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginLoaded extends AuthState {
  final String gmail;
  final String password;

  const LoginLoaded(this.gmail, this.password);
}

final class LoginFauilar extends AuthState {
  final String message;

  const LoginFauilar(this.message);
}

final class RegisterLoading extends AuthState {}

final class RegisterLoaded extends AuthState {}

final class RegisterFauilar extends AuthState {
  final String message;

  const RegisterFauilar(this.message);
}

final class GoogleLoading extends AuthState {}

final class GoogleLoaded extends AuthState {}

final class GoogleFauilar extends AuthState {
  final String message;

  const GoogleFauilar(this.message);
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordEmailSentSuccess extends AuthState {
  final String email;

  const ForgotPasswordEmailSentSuccess(this.email);
}

class ForgotPasswordEmailSentFailure extends AuthState {
  final String error;
  const ForgotPasswordEmailSentFailure(this.error);
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutFailure extends AuthState {
  final String error;

  const SignOutFailure(this.error);
}

class GetUserId extends AuthState {}

class ChangeState extends AuthState {}

class SaveDateLoading extends AuthState {}

class SaveDateLoaded extends AuthState {}

class SaveDateFailur extends AuthState {
  final String error;
  const SaveDateFailur(this.error);
}
