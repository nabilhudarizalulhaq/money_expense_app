import 'package:flutter/material.dart';

class IconCatagory extends StatelessWidget {
  final Widget image;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const IconCatagory({
    super.key,
    required this.image,
    this.backgroundColor = Colors.teal,
    this.iconColor = Colors.white,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      // height: 56,
      width: 56,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: image,
    );
  }
}
