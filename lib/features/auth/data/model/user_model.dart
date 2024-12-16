enum UserRole { user, photographer, makeupArtist }

UserRole? getUserRole(String role) {
  switch (role) {
    case "user":
      return "user" as UserRole;
    case "photographer":
      return "photographer" as UserRole;
    case "makeupArtist":
      return "makeupArtist" as UserRole;
    default:
      return null;
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? role;
  final bool isProfileComplete;
  final bool isSeletectRole;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      this.isSeletectRole = false,
      this.isProfileComplete = false});

  factory UserModel.fromDoc(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'] ?? "",
      name: doc['name'] ?? "",
      email: doc['email'] ?? "",
      role: doc['role'] ?? "",
      isProfileComplete: doc['isProfileComplete'] ?? false,
      isSeletectRole: doc['isSeletectRole'] ?? false,
    );
  }

  Map<String, Object> toDoc() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role ?? "",
      'isProfileComplete': isProfileComplete,
      "isSeletectRole": isSeletectRole
    };
  }

  List<Object?> get grops => [id, name, email, role];
}
