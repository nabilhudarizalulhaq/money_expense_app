import 'package:drift/drift.dart';
import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/models/models.dart';

class TransactionRepository {
  final AppDatabase db;

  TransactionRepository(this.db);

  Future<int> insertTransaction(TransactionModel transaction) async {
    return await db.into(db.transactions).insert(transaction.toCompanion());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final query = await db.select(db.transactions).get();
    return query.map(TransactionModel.fromDrift).toList();
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    final rows =
        await (db.update(db.transactions)
              ..where((t) => t.id.equals(transaction.id!)))
            .write(transaction.toCompanion());
    return rows > 0;
  }

  Future<bool> deleteTransaction(int id) async {
    final rows = await (db.delete(
      db.transactions,
    )..where((t) => t.id.equals(id))).go();
    return rows > 0;
  }

  // ---------------- TOTAL HARI INI ----------------
  Future<double> getTotalToday() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final query = db.select(db.transactions)
      ..where((t) => t.date.isBetweenValues(start, end));

    final result = await query.get();
    return result.fold<double>(0, (prev, element) => prev + element.amount);
  }

  // ---------------- TOTAL BULAN INI ----------------
  Future<double> getTotalThisMonth() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, 1);
    final end = DateTime(today.year, today.month + 1, 1);

    final query = db.select(db.transactions)
      ..where((t) => t.date.isBetweenValues(start, end));

    final result = await query.get();
    return result.fold<double>(0, (prev, element) => prev + element.amount);
  }

  // ---------------- BERDASARKAN KATAGORI ----------------

  Future<double> getTotalByCategory(int categoryId) async {
    final result = await (db.select(
      db.transactions,
    )..where((t) => t.categoryId.equals(categoryId))).get();

    double total = 0.0;
    for (var t in result) {
      total += t.amount;
    }
    return total;
  }
}
