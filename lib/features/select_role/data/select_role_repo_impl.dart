import 'package:el_wedding/core/helpers/sheard_pref.dart';
import 'package:el_wedding/features/select_role/domain/select_role_repo.dart';

class SelectRoleRepoImpl extends SelectRoleRepo {
  @override
  Future<void> setSelectRole(String key, role) async {
    await SharedPrefs().setString(key, role);
  }

  @override
  String? getSelectRole(String key) {
    final result = SharedPrefs().getString(key);

    return result;
  }
}
