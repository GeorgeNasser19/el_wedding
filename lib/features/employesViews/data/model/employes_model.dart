import 'dart:io';

class EmployesModel {
  final String id;
  final String imageUrl; // رابط الصورة
  final File? image; // ملف الصورة (للاستخدام المحلي فقط)
  final String fName;
  final String location;
  final int pNumber;
  final String description;
  final List<Map<String, dynamic>> services;
  final List<String> images;
  EmployesModel({
    required this.images,
    required this.id,
    this.image,
    required this.imageUrl,
    required this.fName,
    required this.location,
    required this.pNumber,
    required this.description,
    required this.services,
  });

  Map<String, Object> toDoc() {
    return {
      'imageUrl': imageUrl,
      'fName': fName,
      'location': location,
      'pNumber': pNumber,
      'images': images,
      'description': description,
      'services': services.map((service) {
        return {
          'name': service['name'],
          'price': service['price'],
        };
      }).toList(),
    };
  }

  factory EmployesModel.fromDoc(Map<String, dynamic> data) {
    // التأكد من التعامل مع الحقول بشكل مناسب
    return EmployesModel(
      fName: data['fName'] ?? '',
      location: data['location'] ?? '',
      pNumber: data['pNumber'] ?? '',
      description: data['description'] ?? '',
      services: (data['services'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? [],
      id: data['id'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
