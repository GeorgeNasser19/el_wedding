import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/show_pic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageEdit extends StatefulWidget {
  final Function(List<String>) onImagePicked;
  final List<XFile>? initialImages; // الصور من الداتابيس (URLs أو Local Paths)

  const MultiImageEdit({
    super.key,
    required this.onImagePicked,
    this.initialImages,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MultiImageEditState createState() => _MultiImageEditState();
}

class _MultiImageEditState extends State<MultiImageEdit> {
  final ImagePicker _picker = ImagePicker();
  late List<XFile> _images; // خليط من URLs و Local Paths

  @override
  void initState() {
    super.initState();
    _images = widget.initialImages ?? [];
  }

  Future<void> _pickImages() async {
    try {
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null) {
        setState(() {
          // إضافة الصور الجديدة إلى القائمة
          _images.addAll(
              pickedFiles); // الحفاظ على النوع XFile داخل القائمة المحلية
          widget.onImagePicked(
            _images.map((file) => file.path).toList(), // تحويل XFile إلى String
          );
          log(_images.length.toString());
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error in pick image : $e'),
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      widget.onImagePicked(
          _images.map((file) => file.path).toList()); // تحويل XFile إلى String
    });
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http') || path.startsWith('https');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Gallery",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _images.length > 6
                  ? TextButton(
                      onPressed: () {
                        context.push("/GalaryPage",
                            extra: _images.map((file) => file.path).toList());
                      },
                      child: const Text("show more...",
                          style: TextStyle(color: Colors.black, fontSize: 15)))
                  : const Text("")
            ],
          ),
          const SizedBox(height: 5),
          _images.isEmpty
              ? const Text('No images selected yet.')
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _images.length > 5 ? 6 : _images.length,
                  itemBuilder: (context, index) {
                    final imagePath = _images[index];
                    return GestureDetector(
                      onTap: () {
                        showPicDialog(context, imagePath.path);
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _isNetworkImage(imagePath.path)
                                  ? CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      imageUrl: imagePath.path,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : Image.file(
                                      File(imagePath.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          TextButton.icon(
            onPressed: _pickImages,
            icon: const Icon(Icons.add),
            label: const Text('Pick Images'),
          ),
        ],
      ),
    );
  }
}
