import 'package:flutter/material.dart';
import 'package:money_expense/shared/theme.dart';

class BottomSheetCategory extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onSelected;

  const BottomSheetCategory({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ListCategoryData.categories;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 28, left: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pilih Kategori",
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ),

          // Grid list category
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];

                return GestureDetector(
                  onTap: () {
                    onSelected(cat);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              ListCategoryData.categoryColors[cat.replaceAll(
                                ' ',
                                '',
                              )] ??
                              Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child:
                            CategoryIcon.categoryIcons[cat.replaceAll(
                              ' ',
                              '',
                            )] ??
                            const Icon(
                              Icons.category,
                              color: Colors.white,
                              size: 30,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
