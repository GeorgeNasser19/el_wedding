import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.onpressed,
    required this.bgColor,
    required this.child,
    this.colorBorder,
  });

  final VoidCallback onpressed;
  final Color bgColor;
  final Widget child;
  final Color? colorBorder;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(bgColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            side: colorBorder != null
                ? BorderSide(
                    color: colorBorder!,
                    width: 2,
                  )
                : BorderSide.none, // إذا لم يكن هناك لون، لا يتم تعيين حد
          ),
        ),
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
      ),
      onPressed: onpressed,
      child: child,
    );
  }
}
