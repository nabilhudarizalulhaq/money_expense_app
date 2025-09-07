import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/core/data/repositories/user_repository.dart';
import 'package:money_expense/persentation/add%20new%20expe/add_new_expense.dart';
import 'package:money_expense/persentation/home/bloc/transaction/transaction_bloc.dart';
import 'package:money_expense/persentation/home/bloc/transaction/transaction_event.dart';
import 'package:money_expense/persentation/home/bloc/transaction/transaction_state.dart';

import 'package:money_expense/persentation/home/widget/card_todat&mount/card_today&mount.dart';
import 'package:money_expense/persentation/home/widget/card_with_category/expense_catagory.dart';
import 'package:money_expense/persentation/home/widget/card_today/expense_today.dart';
import 'package:money_expense/persentation/home/widget/home_list/expense_yesterday.dart';

class HomePage extends StatelessWidget {
  final AppDatabase db;

  const HomePage({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final userRepo = UserRepository(db);
    final transactionRepo = TransactionRepository(db);
    final categoryRepo = CategoryRepository(db);

    return BlocProvider(
      create: (_) => TransactionBloc(
        transactionRepo: transactionRepo,
        categoryRepo: categoryRepo,
      )..add(LoadTransactions()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          children: [
            FutureBuilder(
              future: userRepo.getAllUsers(),
              builder: (context, snapshot) {
                String greeting = 'User';
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  greeting = snapshot.data!.first.name;
                }
                return Text(
                  'Halo, $greeting!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            const Text(
              'Jangan lupa catat keuanganmu setiap hari!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Card Progress - total pengeluaran hari ini & bulan ini
            CardTodayAndMount(transactionRepo: transactionRepo),

            const SizedBox(height: 20),
            const Text(
              'Pengeluaran berdasarkan kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ExpenseCategory(
              transactionRepo: transactionRepo,
              categoryRepo: categoryRepo,
            ),
            const SizedBox(height: 28),
            const Text(
              'Hari ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Expense Today
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  return ExpenseToday(
                    categories: state.categories,
                    transactions: state.todayTransactions,
                  );
                } else {
                  return const Text('Tidak ada data hari ini');
                }
              },
            ),

            const SizedBox(height: 28),
            const Text(
              'Kemarin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Expense Yesterday
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  return ExpenseYesterday(
                    transactions: state.transactionsYesterday,
                    categories: state.categories,
                  );
                } else {
                  return const Text('Tidak ada data kemarin');
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0A97B0),
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddNewExpense(db: db)),
            );
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}
