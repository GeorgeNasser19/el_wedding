// enum UserRole { user, photographer, makeupArtist }

// UserRole? getUserRole(String role) {
//   switch (role) {
//     case "User":
//       return UserRole.user;
//     case "Photographer":
//       return UserRole.photographer;
//     case "Makeup Artist":
//       return UserRole.makeupArtist;
//     default:
//       return null;
//   }
// }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String password;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.password});

  Map<String, Object> toDoc() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  static UserModel fromDoc(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      role: doc['role'],
      password: doc['password'],
    );
  }

  List<Object?> get grops => [id, name, email, role];
}
