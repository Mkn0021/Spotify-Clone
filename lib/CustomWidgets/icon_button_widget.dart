import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onTap,
    this.rotate = false,
    this.size, 
  });

  final Icon icon;
  final Function()? onTap;
  final bool rotate;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap ?? (() {}),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Transform.rotate(
          angle: rotate ? 3.14159*3/2 : 0.0,
          child: Icon(
            icon.icon,
            color: Colors.white,
            size: size??24,
          ),
        ),
      ),
    );
  }
}
