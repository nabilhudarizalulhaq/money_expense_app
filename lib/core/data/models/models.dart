import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:drift/drift.dart';
import 'package:money_expense/core/data/models/hash_helper.dart';

// ---------------- CATEGORY ----------------
class CategoryModel {
  final int? id;
  final String name;
  final String? color;
  final String? iconName;

  CategoryModel({this.id, required this.name, this.color, this.iconName});

  factory CategoryModel.fromDrift(CategoryData c) => CategoryModel(
    id: c.id,
    name: c.name,
    color: c.color,
    iconName: c.iconName,
  );

  CategoriesCompanion toCompanion() => CategoriesCompanion(
    id: id != null ? Value(id!) : const Value.absent(),
    name: Value(name),
  );
}

// ---------------- USER ----------------
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password; // plain

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  UserModel copyWith({int? id, String? name, String? email, String? password}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  factory UserModel.fromDrift(UserData u) =>
      UserModel(id: u.id, name: u.name, email: u.email, password: u.password);

  UsersCompanion toCompanion() {
    final hashed = HashHelper.hashPassword(password); // ✅ langsung pakai helper
    return UsersCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      name: Value(name),
      email: Value(email),
      password: Value(hashed),
    );
  }
}

// ---------------- TRANSACTION ----------------
class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final int categoryId;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
  });

  factory TransactionModel.fromDrift(TransactionData t) => TransactionModel(
    id: t.id,
    title: t.title,
    amount: t.amount,
    categoryId: t.categoryId,
    date: t.date,
  );

  TransactionsCompanion toCompanion() => TransactionsCompanion(
    id: id != null ? Value(id!) : const Value.absent(),
    title: Value(title),
    amount: Value(amount),
    categoryId: Value(categoryId),
    date: Value(date),
  );
}

class TransactionWithCategory {
  final TransactionModel transaction;
  final CategoryModel category;

  TransactionWithCategory(this.transaction, this.category);
}
