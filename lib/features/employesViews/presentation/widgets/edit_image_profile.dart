import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditImageProfile extends StatelessWidget {
  const EditImageProfile({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 500),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  imageUrl: image,
                ),
              ),
              Positioned(
                  bottom: -15,
                  right: -15,
                  child: SizedBox(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              width: double.infinity,
                              color: Colors.grey[200],
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'This is a Bottom Sheet',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
