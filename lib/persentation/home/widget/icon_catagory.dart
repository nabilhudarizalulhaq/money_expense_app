import 'package:flutter/material.dart';

class IconCatagory extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const IconCatagory({
    super.key,
    required this.icon,
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
      child: Icon(icon, color: iconColor, size: size),
    );
  }
}
