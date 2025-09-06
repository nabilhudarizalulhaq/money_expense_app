import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

// ---------------- TABLES ----------------
@DataClassName('UserData')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
}

@DataClassName('CategoryData')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DataClassName('TransactionData')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  DateTimeColumn get date => dateTime()();
}

// ---------------- DATABASE ----------------
@DriftDatabase(tables: [Users, Categories, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ---------------- USERS ----------------
  Future<int> insertUser(UserData user) async {
    final hashed = PasswordHelper.hashPassword(user.password);
    final companion = UsersCompanion(
      name: Value(user.name),
      email: Value(user.email),
      password: Value(hashed),
    );
    return into(users).insert(companion);
  }

  Future<UserData?> getUserByEmail(String email) =>
      (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();

  Future<UserData?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user == null) return null;
    return user.password == PasswordHelper.hashPassword(password) ? user : null;
  }

  Future<bool> updateUserPassword(int userId, String newPassword) async {
    final hashed = PasswordHelper.hashPassword(newPassword);
    final updated = await (update(users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(password: Value(hashed)));
    return updated > 0;
  }

  Future<bool> deleteUser(int userId) async {
    final deleted =
        await (delete(users)..where((u) => u.id.equals(userId))).go();
    return deleted > 0;
  }

  // ---------------- CATEGORIES ----------------
  Future<int> insertCategory(CategoryData category) async =>
      into(categories).insert(category.toCompanion(false));

  Future<List<CategoryData>> getAllCategories() => select(categories).get();

  Future<bool> updateCategory(int id, String newName) async {
    final updated = await (update(categories)..where((c) => c.id.equals(id)))
        .write(CategoriesCompanion(name: Value(newName)));
    return updated > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final deleted =
        await (delete(categories)..where((c) => c.id.equals(id))).go();
    return deleted > 0;
  }

  // ---------------- TRANSACTIONS ----------------
  Future<int> insertTransaction(TransactionData t) async =>
      into(transactions).insert(t.toCompanion(false));

  Future<bool> updateTransaction(
    int id, {
    String? title,
    double? amount,
    int? categoryId,
    DateTime? date,
  }) async {
    final updated = await (update(transactions)..where((t) => t.id.equals(id)))
        .write(
          TransactionsCompanion(
            title: title != null ? Value(title) : const Value.absent(),
            amount: amount != null ? Value(amount) : const Value.absent(),
            categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
            date: date != null ? Value(date) : const Value.absent(),
          ),
        );
    return updated > 0;
  }

  Future<bool> deleteTransaction(int id) async {
    final deleted =
        await (delete(transactions)..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }

  Future<List<TransactionWithCategory>> getAllTransactions() =>
      (select(transactions)..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
          .join([
            leftOuterJoin(
              categories,
              categories.id.equalsExp(transactions.categoryId),
            ),
          ])
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
          })
          .get();
}

// ---------------- PASSWORD HELPER ----------------
class PasswordHelper {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

// ---------------- EXTENSIONS ----------------
extension CategoryDataX on CategoryData {
  CategoriesCompanion toCompanion([bool nullToAbsent = false]) =>
      CategoriesCompanion(
        id: Value(id),
        name: Value(name),
      );
}

extension TransactionDataX on TransactionData {
  TransactionsCompanion toCompanion([bool nullToAbsent = false]) =>
      TransactionsCompanion(
        id: Value(id),
        title: Value(title),
        amount: Value(amount),
        categoryId: Value(categoryId),
        date: Value(date),
      );
}

// ---------------- DATABASE CONNECTION ----------------
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'money_expense.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}

// ---------------- HELPER CLASSES ----------------
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
