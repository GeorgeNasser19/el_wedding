// ignore: depend_on_referenced_packages
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthState> {
  AuthCubitCubit(this.authRepoUsecase) : super(AuthInit());

  @override
  void onChange(change) {
    super.onChange(change);
    log(change.toString());
  }

  final AuthRepoUsecase authRepoUsecase;

  Future<void> login(String email, String password) async {
    if (state is! LoginLoading) {
      emit(LoginLoading());
    }

    final result = await authRepoUsecase.login(email, password);

    result.fold(
      (fail) => emit(LoginFauilar(fail)),
      (_) => emit(LoginLoaded(email, password)),
    );
  }

  Future<void> register(
      String email, String password, String name, String role) async {
    emit(RegisterLoading());
    final result = await authRepoUsecase.register(name, email, password, role);

    result.fold(
      (fail) => emit(RegisterFauilar((fail.toString()))),
      (user) => emit(RegisterLoaded(user)),
    );
  }

  void logout() {
    emit(SignOut());
    authRepoUsecase.logout();
  }

  Future<void> signInWithGoogle() async {
    emit(GoogleLoading());
    final result = await authRepoUsecase.signWithGoogle();

    result.fold(
      (error) {
        if (error == "new_user") {
          emit(GoogleNewUser()); // حالة جديدة للمستخدم
        } else {
          emit(GoogleFauilar(error)); // أي خطأ آخر
        }
      },
      (user) {
        emit(GoogleLoaded(user)); // تسجيل الدخول ناجح
      },
    );
  }

  Future<void> forgetPassword(String email) async {
    emit(ForgotPasswordLoading());
    final result = await authRepoUsecase.forgetPassword(email);

    result.fold(
      (error) {
        emit(ForgotPasswordEmailSentFailure(error)); // حالة جديدة للمستخدم
      },
      (_) {
        emit(ForgotPasswordEmailSentSuccess(email)); // تسجيل الدخول ناجح
      },
    );
  }
}
