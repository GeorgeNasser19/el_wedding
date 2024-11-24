enum UserRole { user, photographer, makeupArtist }

UserRole? getUserRole(String role) {
  switch (role) {
    case "user":
      return UserRole.user;
    case "photographer":
      return UserRole.photographer;
    case "makeupArtist":
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
      'role': role,
    };
  }

  List<Object?> get grops => [id, name, email, role];
}
