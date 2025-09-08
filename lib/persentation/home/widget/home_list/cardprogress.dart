import 'package:flutter/material.dart';

class CardProgres extends StatelessWidget {
  final String title; // Judul card
  final String amount; // Nominal
  final Color backgroundColor; // Warna background card
  final Color titleColor; // Warna teks judul
  final Color amountColor; // Warna teks nominal

  const CardProgres({
    super.key,
    required this.title,
    required this.amount,
    this.backgroundColor = Colors.teal,
    this.titleColor = Colors.white,
    this.amountColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      // width: 180,
      width: (MediaQuery.of(context).size.width - 60) / 2,
      // height: 120,
      height: (MediaQuery.of(context).size.width - 60) / 2 * 0.66,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: titleColor,
            ),
          ),
          Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
