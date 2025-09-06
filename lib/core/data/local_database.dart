// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

// part 'local_database.g.dart';

// // ---- Definisi Table ----
// class Users extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text()();
//   TextColumn get email => text().customConstraint('UNIQUE')();
//   TextColumn get password => text()();
// }

// class Categories extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text()();
// }

// class Transactions extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text()();
//   RealColumn get amount => real()();
//   IntColumn get categoryId => integer().references(Categories, #id)();
//   DateTimeColumn get date => dateTime()();
// }

// // ---- Database ----
// @DriftDatabase(tables: [Users, Categories, Transactions])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 1;

//   // --- User Query ---
//   Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

//   Future<User?> getUserByEmail(String email) =>
//       (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();

//   // --- Category Query ---
//   Future<int> insertCategory(CategoriesCompanion category) =>
//       into(categories).insert(category);

//   Future<List<Category>> getAllCategories() => select(categories).get();

//   // --- Transaction Query ---
//   Future<int> insertTransaction(TransactionsCompanion transaction) =>
//       into(transactions).insert(transaction);

//   Future<List<TransactionWithCategory>> getAllTransactions() =>
//       (select(transactions)
//             ..orderBy([
//               (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
//             ]))
//           .join([
//             leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId))
//           ])
//           .map((row) {
//             return TransactionWithCategory(
//               id: row.readTable(transactions).id,
//               title: row.readTable(transactions).title,
//               amount: row.readTable(transactions).amount,
//               date: row.readTable(transactions).date,
//               category: row.readTableOrNull(categories)?.name ?? 'Unknown',
//             );
//           }).get();

//   // --- Filter transaksi Hari Ini ---
//   Future<List<TransactionWithCategory>> getTransactionsToday() {
//     final now = DateTime.now();
//     final start = DateTime(now.year, now.month, now.day);
//     final end = start.add(const Duration(days: 1));

//     return (select(transactions)
//           ..where((t) => t.date.isBetweenValues(start, end)))
//         .join([
//           leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId))
//         ])
//         .map((row) {
//           return TransactionWithCategory(
//             id: row.readTable(transactions).id,
//             title: row.readTable(transactions).title,
//             amount: row.readTable(transactions).amount,
//             date: row.readTable(transactions).date,
//             category: row.readTableOrNull(categories)?.name ?? 'Unknown',
//           );
//         }).get();
//   }

//   // --- Filter transaksi Kemarin ---
//   Future<List<TransactionWithCategory>> getTransactionsYesterday() {
//     final now = DateTime.now();
//     final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
//     final end = start.add(const Duration(days: 1));

//     return (select(transactions)
//           ..where((t) => t.date.isBetweenValues(start, end)))
//         .join([
//           leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId))
//         ])
//         .map((row) {
//           return TransactionWithCategory(
//             id: row.readTable(transactions).id,
//             title: row.readTable(transactions).title,
//             amount: row.readTable(transactions).amount,
//             date: row.readTable(transactions).date,
//             category: row.readTableOrNull(categories)?.name ?? 'Unknown',
//           );
//         }).get();
//   }
// }

// // ---- Koneksi database ----
// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'money_expense.sqlite'));
//     return NativeDatabase(file);
//   });
// }

// // ---- Helper class untuk join Transactions + Category ----
// class TransactionWithCategory {
//   final int id;
//   final String title;
//   final double amount;
//   final String category;
//   final DateTime date;

//   TransactionWithCategory({
//     required this.id,
//     required this.title,
//     required this.amount,
//     required this.category,
//     required this.date,
//   });
// }
