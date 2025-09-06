import 'package:drift/drift.dart';
import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/models/models.dart';

class CategoryRepository {
  final AppDatabase db;

  CategoryRepository(this.db);

  Future<int> insertCategory(CategoryModel category) async {
    return await db.into(db.categories).insert(category.toCompanion());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final query = await db.select(db.categories).get();
    return query.map(CategoryModel.fromDrift).toList();
  }

  Future<bool> updateCategory(int id, String newName) async {
    final rows = await (db.update(db.categories)..where((c) => c.id.equals(id)))
        .write(CategoriesCompanion(name: Value(newName)));
    return rows > 0;
  }

  Future<bool> deleteCategory(int id) async {
    final rows =
        await (db.delete(db.categories)..where((c) => c.id.equals(id))).go();
    return rows > 0;
  }
}
