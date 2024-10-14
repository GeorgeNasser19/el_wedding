import 'package:bloc/bloc.dart';
import 'package:el_wedding/features/auth/data/auth_repo_imp.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:equatable/equatable.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  AuthCubitCubit(this.authRepoImp) : super(RegisterCubitLoading());

  final AuthRepoImp authRepoImp;

  Future<void> login(String email, String password) async {
    emit(LoginCubitLoading());

    final result = await authRepoImp.login(email, password);

    result.fold((fail) => emit(LoginCubitFauilar(fail)),
        (user) => emit(LoginCubitLoaded(user)));
  }

  Future<void> register(
      String email, String password, String name, UserRole role) async {
    emit(LoginCubitLoading());

    final result = await authRepoImp.register(name, email, password, role);

    result.fold((fail) => emit(LoginCubitFauilar(fail)),
        (user) => emit(LoginCubitLoaded(user)));
  }
}
