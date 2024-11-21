import 'dart:io';

class EmployesModel {
  final String id;
  final String? imageUrl; // رابط الصورة
  final File? image; // ملف الصورة (للاستخدام المحلي فقط)
  final String fName;
  final String location;
  final int pNumber;
  final String description;
  final List<Map<String, dynamic>> services;

  EmployesModel({
    required this.id,
    this.image,
    this.imageUrl,
    required this.fName,
    required this.location,
    required this.pNumber,
    required this.description,
    required this.services,
  });

  Map<String, Object> toDoc() {
    return {
      'imageUrl': imageUrl ?? '',
      'fName': fName,
      'location': location,
      'pNumber': pNumber,
      'description': description,
      'services': services.map((service) {
        return {
          'name': service['name'],
          'price': service['price'],
        };
      }).toList(),
    };
  }

  factory EmployesModel.fromDoc(Map<String, dynamic> doc) {
    return EmployesModel(
      id: doc['id'],
      imageUrl: doc['imageUrl'],
      fName: doc['fName'],
      location: doc['location'],
      pNumber: doc['pNumber'],
      description: doc['description'],
      services: List<Map<String, dynamic>>.from(doc['services']),
    );
  }
}
