import 'package:flutter/material.dart';
import 'package:money_expense/persentation/add%20new%20expe/add_new_expense.dart';
import 'package:money_expense/persentation/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Expense',
      routes: {
        '/': (context) => const HomePage(),
      '/add': (context) => const AddNewExpense()
      },
    );
  }
}
