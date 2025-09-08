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

import 'package:money_expense/persentation/home/widget/card_today&mount/card_today&mount.dart';
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
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Color(0xFF0A97B0)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Color(0xFF828282)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF828282)),
                onPressed: () {},
              ),
            ],
          ),
        ),
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
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            const Text(
              'Jangan lupa catat keuanganmu setiap hari!',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF828282),
              ),
            ),
            const SizedBox(height: 20),

            // Card Progress - total pengeluaran hari ini & bulan ini
            CardTodayAndMount(transactionRepo: transactionRepo),

            const SizedBox(height: 20),
            const Text(
              'Pengeluaran berdasarkan kategori',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ExpenseCategory(
              transactionRepo: transactionRepo,
              categoryRepo: categoryRepo,
            ),
            const SizedBox(height: 28),
            const Text(
              'Hari ini',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
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
                  return Center(
                    child: Text(
                      'Tidak ada data hari ini',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 28),
            const Text(
              'Kemarin',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
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
                  return Center(
                    child: Text(
                      'Tidak ada data kemarin',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  );
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
