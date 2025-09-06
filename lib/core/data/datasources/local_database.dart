import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'local_database.g.dart';

// ---- Tabel ----
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text().customConstraint('UNIQUE')();
  TextColumn get password => text()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  DateTimeColumn get date => dateTime().indexed()();
}

extension on ColumnBuilder<DateTime> {
  indexed() {}
}

// ---- Database ----
@DriftDatabase(tables: [Users, Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ---------------- USERS ----------------
  Future<int> insertUser(String name, String email, String plainPassword) async {
    final hashedPassword = _hashPassword(plainPassword);
    return into(users).insert(
      UsersCompanion.insert(name: name, email: email, password: hashedPassword),
    );
  }

  Future<User?> getUserByEmail(String email) =>
      (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();

  Future<User?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user == null) return null;
    return user.password == _hashPassword(password) ? user : null;
  }

  Future<bool> updateUserPassword(int userId, String newPassword) async {
    final hashed = _hashPassword(newPassword);
    final updated = await (update(users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(password: Value(hashed)));
    return updated > 0;
  }

  Future<bool> deleteUser(int userId) async {
    final deleted = await (delete(users)..where((u) => u.id.equals(userId))).go();
    return deleted > 0;
  }

  // ---------------- CATEGORIES ----------------
  Future<int> insertCategory(String name) =>
      into(categories).insert(CategoriesCompanion.insert(name: name));

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<bool> updateCategory(int id, String newName) async {
    final updated = await (update(categories)..where((c) => c.id.equals(id)))
        .write(CategoriesCompanion(name: Value(newName)));
    return updated > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final deleted = await (delete(categories)..where((c) => c.id.equals(id))).go();
    return deleted > 0;
  }

  // ---------------- TRANSACTIONS ----------------
  Future<int> insertTransaction(String title, double amount, int categoryId, DateTime date) =>
      into(transactions).insert(TransactionsCompanion.insert(
        title: title,
        amount: amount,
        categoryId: categoryId,
        date: date,
      ));

  Future<bool> updateTransaction(int id,
      {String? title, double? amount, int? categoryId, DateTime? date}) async {
    final updated = await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        title: title != null ? Value(title) : Value.absent(),
        amount: amount != null ? Value(amount) : Value.absent(),
        categoryId: categoryId != null ? Value(categoryId) : Value.absent(),
        date: date != null ? Value(date) : Value.absent(),
      ),
    );
    return updated > 0;
  }

  Future<bool> deleteTransaction(int id) async {
    final deleted = await (delete(transactions)..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }

  Future<List<TransactionWithCategory>> getAllTransactions() =>
      (select(transactions)
            ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
          .join([leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId))])
          .map((row) {
            final t = row.readTable(transactions);
            final c = row.readTableOrNull(categories);
            return TransactionWithCategory(
              id: t.id,
              title: t.title,
              amount: t.amount,
              date: t.date,
              category: c?.name ?? 'Unknown',
            );
          }).get();

  // ---------------- FILTER TRANSAKSI ----------------
  Future<List<TransactionWithCategory>> getTransactionsToday() => _getTransactionsByRange(
      DateTime.now(), DateTime.now().add(const Duration(days: 1)));

  Future<List<TransactionWithCategory>> getTransactionsYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _getTransactionsByRange(yesterday, yesterday.add(const Duration(days: 1)));
  }

  Future<List<TransactionWithCategory>> getTransactionsThisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return _getTransactionsByRange(start, end);
  }

  Future<List<TransactionWithCategory>> getTransactionsThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = (now.month == 12)
        ? DateTime(now.year + 1, 1, 1)
        : DateTime(now.year, now.month + 1, 1);
    return _getTransactionsByRange(start, end);
  }

  Future<List<TransactionWithCategory>> _getTransactionsByRange(DateTime start, DateTime end) {
    return (select(transactions)
          ..where((t) => t.date.isBetweenValues(start, end)))
        .join([leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId))])
        .map((row) {
          final t = row.readTable(transactions);
          final c = row.readTableOrNull(categories);
          return TransactionWithCategory(
            id: t.id,
            title: t.title,
            amount: t.amount,
            date: t.date,
            category: c?.name ?? 'Unknown',
          );
        }).get();
  }

  // ---------------- LAPORAN ----------------
  Future<Map<String, double>> getTotalPerCategory() async {
    final query = await (select(transactions)
          .join([leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId))])
        ).get();

    final Map<String, double> totals = {};
    for (var row in query) {
      final t = row.readTable(transactions);
      final c = row.readTableOrNull(categories);
      final name = c?.name ?? 'Unknown';
      totals[name] = (totals[name] ?? 0) + t.amount;
    }
    return totals;
  }

  // ---------------- HELPER ----------------
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

// ---- Koneksi database ----
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'money_expense.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}

// ---- Helper class untuk join Transactions + Category ----
class TransactionWithCategory {
  final int id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  TransactionWithCategory({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}
