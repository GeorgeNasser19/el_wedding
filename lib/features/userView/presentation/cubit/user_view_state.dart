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
  @override
  List<Object> get props => [message];
}

final class SetDateLoading extends UserViewState {}

final class SetDateLoaded extends UserViewState {
  final UserModel userModel;

  const SetDateLoaded(this.userModel);

  @override
  List<Object> get props => [userModel];
}

final class SetDateFauiler extends UserViewState {
  final String message;

  const SetDateFauiler(this.message);

  @override
  List<Object> get props => [message];
}
