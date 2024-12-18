import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GalaryPage extends StatelessWidget {
  const GalaryPage({super.key, required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Full Galary",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 245, 241, 241),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                String imagePath = images[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            true, // يسمح بالإغلاق عند النقر خارج الصورة
                        builder: (context) {
                          return GestureDetector(
                            onVerticalDragUpdate: (details) {
                              if (details.primaryDelta! > 10) {
                                Navigator.pop(context); // يغلق عند السحب لأسفل
                              }
                            },
                            child: Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding:
                                  EdgeInsets.zero, // استخدام كامل الشاشة
                              child: PhotoView(
                                enableRotation: true,
                                imageProvider: NetworkImage(imagePath),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2,
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
