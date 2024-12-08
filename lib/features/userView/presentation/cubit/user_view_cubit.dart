import 'package:bloc/bloc.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/userView/domain/usecase_user_view/usecase_user_view.dart';
import 'package:equatable/equatable.dart';

part 'user_view_state.dart';

class UserViewCubit extends Cubit<UserViewState> {
  UserViewCubit(this.usecaseUserView) : super(UserViewInitial());

  final UsecaseUserView usecaseUserView;

  Future<void> fetchDate(String userID) async {
    final result = await usecaseUserView.fetchUserModel(userID);

    emit(UserViewLoading());

    result.fold((fail) => emit(UserViewFauilar(fail)),
        (load) => emit(UserViewLoaded(load)));
  }
}
