import 'package:flutter/material.dart';
import 'package:money_expense/persentation/home/widget/card_expense_catagory.dart';

class ExpenseCatagory extends StatefulWidget {
  const ExpenseCatagory({super.key});

  @override
  State<ExpenseCatagory> createState() => _ExpenseCatagoryState();
}

class _ExpenseCatagoryState extends State<ExpenseCatagory> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 20,
        children: [
          CardExpenseCatagory(
            title: 'Makanan',
            amount: 'Rp 1.200.000',
            backgroundColor: Colors.orange,
            icon: Icons.fastfood,
          ),

          CardExpenseCatagory(
            title: 'Transportasi',
            amount: 'Rp 800.000',
            backgroundColor: Colors.blue,
            icon: Icons.directions_car,
          ),

          CardExpenseCatagory(
            title: 'Hiburan',
            amount: 'Rp 500.000',
            backgroundColor: Colors.purple,
            icon: Icons.movie,
          ),

          CardExpenseCatagory(
            title: 'Belanja',
            amount: 'Rp 1.000.000',
            backgroundColor: Colors.teal,
            icon: Icons.shopping_bag,
          ),
        ],
      ),
    );
  }
}
