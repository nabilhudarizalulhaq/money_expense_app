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
            offset: const Offset(-2, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconCatagory(icon: icon, backgroundColor: backgroundColor),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:money_expense/persentation/home/widget/icon_catagory.dart';

// class CardExpenseCatagory extends StatefulWidget {
//   const CardExpenseCatagory({super.key});

//   @override
//   State<CardExpenseCatagory> createState() => _CardExpenseCatagoryState();
// }

// class _CardExpenseCatagoryState extends State<CardExpenseCatagory> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       // height: 120,
//       width: 120,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 7,
//             offset: const Offset(-2, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           IconCatagory(),
//           SizedBox(height: 14),
//           Text('Belanja', style: TextStyle(fontSize: 16)),
//           SizedBox(height: 8),
//           Text(
//             'Rp 200.000',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
