import 'package:flutter/material.dart';
import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/persentation/add%20new%20expe/add_new_expense.dart';
import 'package:money_expense/persentation/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Expense',
      routes: {
        '/': (context) => HomePage(db: db),
        '/add': (context) => AddNewExpense(db: db),
      },
    );
  }
}
