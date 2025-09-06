import 'package:flutter/material.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/persentation/home/widget/card_todat&mount/card_expense_catagory.dart';

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
      future: categoryRepo.getAllCategories(), // Ambil semua kategori
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data!;

        return SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(categories.length, (index) {
              final cat = categories[index];

              return FutureBuilder<double>(
                future: transactionRepo.getTotalByCategory(cat.id!),
                builder: (context, snapAmount) {
                  double amount = snapAmount.data ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CardExpenseCatagory(
                      title: cat.name,
                      amount: 'Rp. ${amount.toStringAsFixed(0)}',
                      backgroundColor: _getCategoryColor(cat.name),
                      icon: _getCategoryIcon(cat.name),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.blue;
      case 'Hiburan':
        return Colors.purple;
      case 'Belanja':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Hiburan':
        return Icons.movie;
      case 'Belanja':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
}
