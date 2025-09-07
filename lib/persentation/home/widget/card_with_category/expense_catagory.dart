import 'package:flutter/material.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/persentation/home/widget/card_with_category/card_expense_catagory.dart';
import 'package:money_expense/shared/theme.dart'; // CategoryIcon & ListCategoryData
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
            final formatter = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp. ',
              decimalDigits: 0,
            );

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: List.generate(categories.length, (index) {
                  final cat = categories[index];
                  final totalAmount = totals[index];
                  final formatted = formatter.format(totalAmount);

                  // key untuk lookup map
                  final catKey = cat.name.replaceAll(' ', '');

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CardExpenseCatagory(
                      title: cat.name,
                      amount: formatted,
                      backgroundColor:
                          ListCategoryData.categoryColors[catKey] ?? Colors.grey,
                      image: CategoryIcon.categoryIcons[catKey] != null
                          ? Icon(
                              Icons.circle, // ikon placeholder
                              color: ListCategoryData.categoryColors[catKey],
                            )
                          : const Icon(Icons.category),
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
}
