import 'package:flutter/material.dart';
import 'package:money_expense/persentation/home/widget/icon_catagory.dart';
import 'package:money_expense/shared/theme.dart';

class CardExpenseCatagory extends StatelessWidget {
  final Widget image;
  final String title;
  final String amount;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const CardExpenseCatagory({
    super.key,
    required this.image,
    required this.title,
    required this.amount,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconCatagory(
            image: CategoryIcon.categoryIcons[title.replaceAll(' ', '')]!,
            backgroundColor: backgroundColor,
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(fontSize: 14, color: textColor)),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
