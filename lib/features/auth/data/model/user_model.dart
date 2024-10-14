enum UserRole { user, photographer, makeupArtist }

UserRole getUserRole(String role) {
  switch (role) {
    case "User":
      return UserRole.user;
    case "Photographer":
      return UserRole.photographer;
    case "MakeupArtist":
      return UserRole.makeupArtist;
    default:
      throw Exception("Invalid role type");
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});
}
