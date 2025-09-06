// import 'package:money_expense/data/datasources/local_database.dart';

// class ExpenseRepository {
//   final AppDatabase db;
//   ExpenseRepository(this.db);

//   // Tambah expense
//   Future<int> addExpense(String title, double amount, int categoryId, DateTime date) {
//     return db.insertExpense(ExpensesCompanion.insert(
//       title: title,
//       amount: amount,
//       categoryId: categoryId,
//       date: date,
//     ));
//   }

//   // Ambil semua expense beserta nama kategori
//   Future<List<Map<String, dynamic>>> getAllExpenses() {
//     return db.getExpensesWithCategory();
//   }

//   // Ambil semua kategori
//   Future<List<CategoriesData>> getAllCategories() {
//     return db.getAllCategories();
//   }
// }
