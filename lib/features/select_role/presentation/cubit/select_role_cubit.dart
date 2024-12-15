// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:el_wedding/features/select_role/domain/usecase_select_role/usecase_select_role.dart';
import 'package:equatable/equatable.dart';

part 'select_role_state.dart';

class SelectRoleCubit extends Cubit<SelectRoleState> {
  SelectRoleCubit(this.usecaseSelectRole) : super(SelectRoleInitial());

  final UsecaseSelectRole usecaseSelectRole;

  Future<void> setSelectRole(String key, role) async {
    emit(SelectRoleLoading());
    await usecaseSelectRole.setSelectRole(key, role);
    emit(SelectRoleLoaded());
  }

  String? getSelectRole(String key) {
    final result = usecaseSelectRole.getSelectRole(key);
    return result.toString();
  }
}
