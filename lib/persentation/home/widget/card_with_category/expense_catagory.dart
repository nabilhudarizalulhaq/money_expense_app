import 'package:flutter/material.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/persentation/home/widget/card_with_category/card_expense_catagory.dart';
import 'package:intl/intl.dart';

class ExpenseCategory extends StatelessWidget {
  final TransactionRepository transactionRepo;
  final CategoryRepository categoryRepo;

  const ExpenseCategory({
    super.key,
    required this.transactionRepo,
    required this.categoryRepo,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: categoryRepo.getAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
``
        final categories = snapshot.data!;

        // get all total category
        final futures = categories
            .map((cat) => transactionRepo.getTotalByCategory(cat.id!))
            .toList();

        return FutureBuilder<List<double>>(
          future: Future.wait(futures),
          builder: (context, totalsSnapshot) {
            if (!totalsSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final totals = totalsSnapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final cat = categories[index];
                  final totalAmount = totals[index];
                  final formatter = NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp. ',
                    decimalDigits: 0,
                  );

                  String formatted = formatter.format(totalAmount);

                  // Warna dan icon dari database
                  final iconData = _getCategoryIcon(cat.name);

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CardExpenseCatagory(
                      title: cat.name,
                      amount: formatted,
                      backgroundColor: _getCategoryColor(cat.name),
                      icon: iconData,
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi mapping warna
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return const Color(0xFFF2C94C);
      case 'Internet':
        return const Color(0xFF56CCF2);
      case 'Edukasi':
        return const Color(0xFFF2994A);
      case 'Hadiah':
        return const Color(0xFFEB5757);
      case 'Transportasi':
        return const Color(0xFF9B51E0);
      case 'Belanja':
        return const Color(0xFF27AE60);
      case 'Alat Rumah':
        return const Color(0xFFBB6BD9);
      case 'Olahraga':
        return const Color(0xFF2D9CDB);
      case 'Hiburan':
        return const Color(0xFF2D9CDB);
      default:
        return Colors.grey;
    }
  }

  // Fungsi mapping ikon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Internet':
        return Icons.wifi;
      case 'Edukasi':
        return Icons.school;
      case 'Hadiah':
        return Icons.card_giftcard;
      case 'Transport':
        return Icons.directions_car;
      case 'Belanja':
        return Icons.shopping_bag;
      case 'Alat Rumah':
        return Icons.home_repair_service;
      case 'Olahraga':
        return Icons.sports;
      case 'Hiburan':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }
}
