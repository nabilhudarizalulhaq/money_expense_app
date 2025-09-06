import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/models/models.dart';

class UserRepository {
  final AppDatabase db;

  UserRepository(this.db);

  Future<int> insertUser(UserModel user) async {
    return await db.into(db.users).insert(user.toCompanion());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final query = await (db.select(
      db.users,
    )..where((u) => u.email.equals(email))).getSingleOrNull();
    return query != null ? UserModel.fromDrift(query) : null;
  }

  Future<UserModel?> login(String email, String password) async {
    final userData = await db.login(email, password);
    return userData != null ? UserModel.fromDrift(userData) : null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final query = await db.select(db.users).get();
    return query.map(UserModel.fromDrift).toList();
  }

  Future<bool> deleteUser(int id) async {
    final rows = await (db.delete(
      db.users,
    )..where((u) => u.id.equals(id))).go();
    return rows > 0;
  }
}
