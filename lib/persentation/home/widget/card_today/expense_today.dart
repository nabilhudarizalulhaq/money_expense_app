import 'package:flutter/material.dart';
import 'package:money_expense/core/data/models/models.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:intl/intl.dart';

class ExpenseToday extends StatelessWidget {
  final TransactionRepository transactionRepo;
  final CategoryRepository categoryRepo; // repository kategori
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  ExpenseToday({
    super.key,
    required this.transactionRepo,
    required this.categoryRepo,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: transactionRepo.getTransactionsToday(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada transaksi hari ini'));
        }

        final transactions = snapshot.data!;

        return FutureBuilder<List<CategoryModel>>(
          future: categoryRepo.getAllCategories(), // ambil semua kategori
          builder: (context, catSnapshot) {
            if (catSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final categories = catSnapshot.data ?? [];

            return Column(
              children: transactions.map((t) {
                // Cari list categories
                final cat = categories.firstWhere(
                  (c) => c.id == t.categoryId,
                  orElse: () => CategoryModel(
                    id: 0,
                    name: 'Unknown',
                    iconName: null,
                    color: null,
                  ),
                );

                _getCategoryIcon(cat.iconName);
                final color = _getCategoryColor(
                  cat.name,
                ); // mapping warna

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(cat.name),
                          color: color,
                          size: 34,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.title,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          formatter.format(t.amount),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
  IconData _getCategoryIcon(String? iconName) {
    switch (iconName) {
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
