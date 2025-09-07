import 'package:flutter/material.dart';
import 'package:money_expense/persentation/home/widget/icon_catagory.dart';

class CardExpenseCatagory extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const CardExpenseCatagory({
    super.key,
    required this.icon,
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
      // width: 120,
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
          IconCatagory(icon: icon, backgroundColor: backgroundColor),
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
