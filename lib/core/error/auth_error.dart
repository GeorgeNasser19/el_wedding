import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// login errors
class LoginFailure extends Failure {
  const LoginFailure(super.message);
}

class InvalidEmailFailure extends LoginFailure {
  const InvalidEmailFailure() : super("Invalid email address.");
}

class UserNotFoundFailure extends LoginFailure {
  const UserNotFoundFailure() : super("User not found.");
}

class WrongPasswordFailure extends LoginFailure {
  const WrongPasswordFailure() : super("Incorrect password.");
}

// register errors
class RegisterFailure extends Failure {
  const RegisterFailure(super.message);
}

class EmailAlreadyInUseFailure extends RegisterFailure {
  const EmailAlreadyInUseFailure() : super("Email is already in use.");
}

class WeakPasswordFailure extends RegisterFailure {
  const WeakPasswordFailure() : super("Password is too weak.");
}

class UnknownAuthFailure extends Failure {
  const UnknownAuthFailure()
      : super("An unknown authentication error occurred.");
}
