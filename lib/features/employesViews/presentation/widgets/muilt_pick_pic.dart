import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePickerWidget extends StatefulWidget {
  final Function(List<String>?) onImagePicked; // تعديل لتأخذ List من الصور

  const MultiImagePickerWidget({
    super.key,
    required this.onImagePicked,
  });

  @override
  _MultiImagePickerWidgetState createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(limit: 5);

      if (images != null) {
        setState(() {
          _selectedImages = images;
        });
        List<String> imagePaths =
            _selectedImages.map((file) => file.path).toList();

        widget.onImagePicked(imagePaths);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصور: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('اختار الصور'),
        ),
        const SizedBox(height: 20),
        _selectedImages.isEmpty
            ? const Text('لم يتم اختيار أي صور بعد.')
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    File(_selectedImages[index].path),
                    fit: BoxFit.cover,
                  );
                },
              ),
      ],
    );
  }
}
