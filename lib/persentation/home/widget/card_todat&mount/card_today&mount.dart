import 'package:flutter/material.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/persentation/home/widget/home_list/cardprogress.dart';

class CardTodayAndMount extends StatelessWidget {
  final TransactionRepository transactionRepo;
  const CardTodayAndMount({super.key, required this.transactionRepo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<double>>(
        future: Future.wait([
          transactionRepo.getTotalToday(),
          transactionRepo.getTotalThisMonth(),
        ]),
        builder: (context, snapshot) {
          double totalToday = 0;
          double totalMonth = 0;

          if (snapshot.hasData) {
            totalToday = snapshot.data![0];
            totalMonth = snapshot.data![1];
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardProgres(
                title: 'Pengeluaranmu \nhari ini',
                amount: 'Rp. ${totalToday.toStringAsFixed(0)}',
                backgroundColor: const Color(0xFF0A97B0),
              ),
              const SizedBox(width: 20),
              CardProgres(
                title: 'Pengeluaranmu \nbulan ini',
                amount: 'Rp. ${totalMonth.toStringAsFixed(0)}',
                backgroundColor: const Color(0xFF46B5A7),
              ),
            ],
          );
        },
      ),
    );
  }
}
