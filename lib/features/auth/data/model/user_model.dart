enum UserRole { user, photographer, makeupArtist }

UserRole? getUserRole(String role) {
  switch (role) {
    case "User":
      return UserRole.user;
    case "Photographer":
      return UserRole.photographer;
    case "Makeup Artist":
      return UserRole.makeupArtist;
    default:
      return null;
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, Object> toDoc() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': getUserRole(role) ?? "w",
    };
  }

  List<Object?> get grops => [id, name, email, role];
}
