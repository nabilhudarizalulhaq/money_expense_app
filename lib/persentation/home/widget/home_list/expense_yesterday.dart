import 'package:flutter/material.dart';
import 'package:money_expense/core/data/models/models.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/shared/theme.dart';

class ExpenseYesterday extends StatelessWidget {
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  ExpenseYesterday({
    super.key,
    required this.transactions,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Belum ada transaksi kemarin'));
    }

    return Column(
      children: categories.map((cat) {
        final catTransactions = transactions
            .where((t) => t.categoryId == cat.id)
            .toList();
        if (catTransactions.isEmpty) return const SizedBox.shrink();

        final totalAmount = catTransactions.fold<double>(
          0,
          (sum, t) => sum + t.amount,
        );

        // key untuk lookup map
        final catKey = cat.name.replaceAll(' ', '');

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
              children: [
                // Icon kategori dengan warna dari ListCategoryData
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    ListCategoryData.categoryColors[catKey] ?? Colors.black,
                    BlendMode.srcIn,
                  ),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CategoryIcon.categoryIcons[catKey],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(cat.name, style: const TextStyle(fontSize: 16)),
                ),
                Text(
                  formatter.format(totalAmount),
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
  }
}
