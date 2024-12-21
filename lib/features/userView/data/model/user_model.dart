import 'dart:io';

class UserModel {
  final String id;
  final String imageUrl;
  final File? image;
  final String fName;

  UserModel({
    required this.id,
    required this.imageUrl,
    required this.fName,
    this.image,
  });

  factory UserModel.fromDoc(Map<String, dynamic> doc) {
    return UserModel(
      id: doc["id"] ?? "",
      imageUrl: doc['imageUrl'] ?? '',
      fName: doc["fName"],
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "fName": fName,
    };
  }
}
