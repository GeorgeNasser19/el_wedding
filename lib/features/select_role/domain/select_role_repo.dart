abstract class SelectRoleRepo {
  Future<void> setSelectRole(String key, role);

  String? getSelectRole(String key);
}
