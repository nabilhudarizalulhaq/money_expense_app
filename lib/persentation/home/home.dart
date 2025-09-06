import 'package:flutter/material.dart';
import 'package:money_expense/persentation/add%20new%20expe/add_new_expense.dart';
import 'package:money_expense/persentation/home/widget/cardprogress.dart';
import 'package:money_expense/persentation/home/widget/expense_catagory.dart';
import 'package:money_expense/persentation/home/widget/expense_today.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: [
          Text(
            'Halo, User!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Jangan lupa catat keuanganmu setiap hari!',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          // Card Progress
          Center(
            child: Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardProgres(
                  title: 'Pemasukan',
                  amount: 'Rp 5.000.000',
                  backgroundColor: Colors.green,
                ),
                CardProgres(
                  title: 'Pengeluaran',
                  amount: 'Rp 3.500.000',
                  backgroundColor: Colors.redAccent,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Pengeluaran berdasarkan kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ExpenseCatagory(),
          SizedBox(height: 28),
          Text(
            'Hari ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Column(
            spacing: 20,
            children: [ExpenseToday(), ExpenseToday(), ExpenseToday()],
          ),
          SizedBox(height: 28),
          Text(
            'Kemarin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Column(
            spacing: 20,
            children: [ExpenseToday(), ExpenseToday(), ExpenseToday()],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A97B0),
        shape: const CircleBorder(),
        onPressed: () {
          // Aksi ketika tombol ditekan
          // Misalnya buka halaman tambah pengeluaran
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNewExpense()),
          );
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
