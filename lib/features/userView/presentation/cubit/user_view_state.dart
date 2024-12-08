part of 'user_view_cubit.dart';

sealed class UserViewState extends Equatable {
  const UserViewState();

  @override
  List<Object> get props => [];
}

final class UserViewInitial extends UserViewState {}

final class UserViewLoading extends UserViewState {}

final class UserViewLoaded extends UserViewState {
  final UserModel userModel;

  const UserViewLoaded(this.userModel);
}

final class UserViewFauilar extends UserViewState {
  final String message;

  const UserViewFauilar(this.message);
}
