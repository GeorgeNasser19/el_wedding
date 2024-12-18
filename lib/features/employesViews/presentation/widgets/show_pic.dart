import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

Future<void> showPicDialog(BuildContext context, String image) {
  return showDialog(
    context: context,
    barrierDismissible: true, // يسمح بالإغلاق عند النقر خارج الصورة
    builder: (context) {
      return GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            Navigator.pop(context); // يغلق عند السحب لأسفل
          }
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero, // استخدام كامل الشاشة
          child: PhotoView(
            enableRotation: true,
            imageProvider: NetworkImage(image),
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
}
