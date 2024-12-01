import 'dart:io';

import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';

class EntityCheakAuth {
  final String id;
  final String? imageUrl; // رابط الصورة
  final File? image; // ملف الصورة (للاستخدام المحلي فقط)
  final String fName;
  final String location;
  final int pNumber;
  final String description;
  final List<Map<String, dynamic>> services;
  final List<String> images;
  final String name;
  final String email;
  final String role;
  final bool isProfileComplete;

  EntityCheakAuth({
    required this.id,
    this.imageUrl,
    this.image,
    required this.fName,
    required this.location,
    required this.pNumber,
    required this.description,
    required this.services,
    required this.images,
    required this.name,
    required this.email,
    required this.role,
    required this.isProfileComplete,
  });

  factory EntityCheakAuth.fromDoc(
      UserModel userModel, EmployesModel employesModel) {
    return EntityCheakAuth(
        id: userModel.id,
        fName: employesModel.fName,
        location: employesModel.location,
        pNumber: employesModel.pNumber,
        description: employesModel.description,
        services: employesModel.services,
        images: employesModel.images,
        name: userModel.name,
        email: userModel.email,
        role: userModel.role,
        isProfileComplete: userModel.isProfileComplete);
  }
}
