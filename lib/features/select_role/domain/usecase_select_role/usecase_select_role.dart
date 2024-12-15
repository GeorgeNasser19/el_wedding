import 'package:el_wedding/features/select_role/domain/select_role_repo.dart';

class UsecaseSelectRole {
  final SelectRoleRepo selectRoleRepo;

  UsecaseSelectRole(this.selectRoleRepo);

  Future<void> setSelectRole(String key, role) async {
    await selectRoleRepo.setSelectRole(key, role);
  }

  String? getSelectRole(String key) {
    final result = selectRoleRepo.getSelectRole(key);
    return result;
  }
}
