// ignore: depend_on_referenced_packages
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/auth/domin/usecase/auth_repo_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepoUsecase) : super(AuthInit());

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

  void logout() async {
    emit(SignOutLoading());

    try {
      await authRepoUsecase.logout(); // نفذ تسجيل الخروج وانتظر النتيجة
      emit(SignOutSuccess()); // حالة النجاح عند إتمام تسجيل الخروج
    } catch (e) {
      emit(SignOutFailure(e.toString())); // حالة الخطأ مع رسالة الخطأ
    }
  }

  Future<void> signInWithGoogle() async {
    if (isClosed) return; // التأكد من أن Cubit لم يُغلق
    emit(GoogleLoading());

    final result = await authRepoUsecase.signWithGoogle();

    if (isClosed) return; // التأكد مرة أخرى بعد انتظار الاستجابة
    result.fold(
      (error) {
        if (isClosed) return; // التأكد من عدم الإغلاق قبل إرسال الحالة
        if (error == "new_user") {
          emit(GoogleNewUser());
        } else {
          emit(GoogleFauilar(error));
        }
      },
      (user) {
        if (!isClosed) emit(GoogleLoaded(user)); // تحقق أخير من isClosed
      },
    );
  }

  Future<void> forgetPassword(String email) async {
    emit(ForgotPasswordLoading());
    final result = await authRepoUsecase.forgetPassword(email);

    result.fold(
      (error) {
        emit(ForgotPasswordEmailSentFailure(error));
      },
      (_) {
        emit(ForgotPasswordEmailSentSuccess(email));
      },
    );
  }

  Future<void> getUserId() async {
    await authRepoUsecase.getUserId();
    emit(GetUserId());
  }

  Future<void> changeState() async {
    authRepoUsecase.changeState();

    emit(ChangeState());
  }
}
