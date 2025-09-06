// // import 'package:money_expense/core/data/datasources/local_database.dart';
// // import 'package:money_expense/core/data/models/models.dart';
// // import 'package:money_expense/core/data/repositories/catagory_repository.dart';
// // import 'package:money_expense/core/data/repositories/user_repository.dart';
// // import 'package:money_expense/core/data/repositories/transaction_repository.dart';

// // Future<void> main() async {
// //   final db = AppDatabase();

// //   final userRepo = UserRepository(db);
// //   final categoryRepo = CategoryRepository(db);
// //   final transactionRepo = TransactionRepository(db);

// //   // Insert User
// //   final userId = await userRepo.insertUser(UserModel(
// //     name: "Nabil",
// //     email: "nabil@example.com",
// //     password: "123456",
// //   ));
// //   print("✅ User inserted: $userId");

// //   // Insert Category
// //   final catId =
// //       await categoryRepo.insertCategory(CategoryModel(name: "Makanan"));
// //   print("✅ Category inserted: $catId");

// //   // Insert Transaction
// //   final trxId = await transactionRepo.insertTransaction(TransactionModel(
// //     title: "Beli Nasi Goreng",
// //     amount: 25000,
// //     categoryId: catId,
// //     date: DateTime.now(),
// //   ));
// //   print("✅ Transaction inserted: $trxId");

// //   // Get all users
// //   final users = await userRepo.getAllUsers();
// //   print("📌 Users: ${users.map((u) => u.email).toList()}");

// //   // Get all categories
// //   final categories = await categoryRepo.getAllCategories();
// //   print("📌 Categories: ${categories.map((c) => c.name).toList()}");

// //   // Get all transactions
// //   final transactions = await transactionRepo.getAllTransactions();
// //   print("📌 Transactions: ${transactions.map((t) => t.title).toList()}");
// // }

// import 'package:money_expense/bloc/user/bloc/user/bloc/user_bloc.dart';
// import 'package:money_expense/bloc/user/bloc/user/bloc/user_event.dart';
// import 'package:money_expense/bloc/user/bloc/user/bloc/user_state.dart';
// import 'package:money_expense/core/data/models/models.dart';
// import 'core/data/datasources/local_database.dart';
// import 'core/data/repositories/user_repository.dart';

// Future<void> main() async {
//   final db = AppDatabase();
//   final userRepo = UserRepository(db);
//   final userBloc = UserBloc(userRepo);

//   // Listen state changes
//   final subscription = userBloc.stream.listen((state) {
//     print("State: $state");
//     if (state is UserSuccess) {
//       print("User berhasil: ${state.user.email}");
//     } else if (state is UserError) {
//       print("Error: ${state.message}");
//     }
//   });

//   // Dispatch add user
//   userBloc.add(AddUser(UserModel(
//     name: "Nabil",
//     email: "nabil@example.com",
//     password: "123456",
//   )));

//   // Dispatch login user
//   userBloc.add(LoginUser("nabil@example.com", "123456"));

//   await Future.delayed(const Duration(seconds: 3));
//   await subscription.cancel();
//   await db.close();
// }

import 'dart:io';

import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/models/models.dart';
import 'package:money_expense/core/data/repositories/user_repository.dart';

Future<void> main() async {
  final db = AppDatabase();
  final userRepo = UserRepository(db);

  print('=== User CLI ===');

  while (true) {
    print('\nPilih aksi:');
    print('1. List all users');
    print('2. Add user');
    print('3. Update user password');
    print('4. Delete user');
    print('5. Exit');
    stdout.write('> ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        final users = await userRepo.getAllUsers();
        if (users.isEmpty) {
          print('Belum ada user.');
        } else {
          for (var u in users) {
            print('ID: ${u.id}, Name: ${u.name}, Email: ${u.email}');
          }
        }
        break;

      case '2':
        stdout.write('Name: ');
        final name = stdin.readLineSync() ?? '';
        stdout.write('Email: ');
        final email = stdin.readLineSync() ?? '';
        stdout.write('Password: ');
        final password = stdin.readLineSync() ?? '';
        final id = await userRepo.insertUser(
          UserModel(name: name, email: email, password: password),
        );
        print('User berhasil ditambahkan dengan ID: $id');
        break;

      case '3':
        stdout.write('User ID: ');
        final idStr = stdin.readLineSync() ?? '';
        final id = int.tryParse(idStr);
        if (id == null) {
          print('ID tidak valid');
          break;
        }

      case '4':
        stdout.write('User ID: ');
        final idStrDel = stdin.readLineSync() ?? '';
        final idDel = int.tryParse(idStrDel);
        if (idDel == null) {
          print('ID tidak valid');
          break;
        }
        final successDel = await userRepo.deleteUser(idDel);
        print(successDel ? 'User berhasil dihapus.' : 'User tidak ditemukan.');
        break;

      case '5':
        await db.close();
        print('Exiting...');
        exit(0);

      default:
        print('Pilihan tidak valid.');
    }
  }
}
