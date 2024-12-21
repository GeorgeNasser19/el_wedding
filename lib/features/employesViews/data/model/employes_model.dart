import 'dart:io';

class EmployeeModel {
  String id;
  String imageUrl;
  final File? image;
  final String fName;
  final String location;
  final int pNumber;
  final String description;
  final List<Map<String, dynamic>> services;
  final List<String>? images;
  List<String> imageUrls;
  double avergeRating;
  int ratingCount;
  List<Map<String, dynamic>> comments;

  EmployeeModel({
    required this.imageUrls,
    required this.id,
    this.image,
    this.images,
    required this.imageUrl,
    required this.fName,
    required this.location,
    required this.pNumber,
    required this.description,
    required this.services,
    this.avergeRating = 0.0,
    this.ratingCount = 0,
    this.comments = const [],
  });

  // دالة تحويل البيانات إلى مستند Firestore
  Map<String, Object> toDoc() {
    return {
      "id": id,
      'imageUrls': imageUrls, // إضافة روابط الصور الإضافية هنا
      'imageUrl': imageUrl, // صورة الملف الشخصي
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
      "avergeRating": avergeRating,
      "ratingCount": ratingCount,
      'comments': comments
    };
  }

  factory EmployeeModel.fromDoc(Map<String, dynamic> data) {
    return EmployeeModel(
        fName: data['fName'] ?? '',
        location: data['location'] ?? '',
        pNumber: data['pNumber'] ?? 0,
        description: data['description'] ?? '',
        services: (data['services'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [],
        id: data['id'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        imageUrls: List<String>.from(
            data['imageUrls'] ?? []), // تأكد من تحويل البيانات بشكل صحيح
        avergeRating: data["avergeRating"] ?? 0.0,
        comments: List<Map<String, dynamic>>.from(data["comments"] ?? []));
  }
}
