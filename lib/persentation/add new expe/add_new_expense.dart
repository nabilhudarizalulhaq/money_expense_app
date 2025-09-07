import 'package:flutter/material.dart';
import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/models/models.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/shared/theme.dart';

class AddNewExpense extends StatefulWidget {
  final AppDatabase db;

  const AddNewExpense({super.key, required this.db});

  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  DateTime? selectedDate;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  String? selectedCategory;

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _saveTransaction() async {
    final name = nameController.text.trim();
    final categoryName = selectedCategory?.trim() ?? '';
    final date = selectedDate ?? DateTime.now();
    final nominal = double.tryParse(nominalController.text.trim()) ?? 0;

    if (name.isEmpty || categoryName.isEmpty || nominal <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua data!')));
      return;
    }

    final categoryRepo = CategoryRepository(widget.db);
    final transactionRepo = TransactionRepository(widget.db);

    // 1. Cek kategori
    List<CategoryModel> existingCategories = await categoryRepo
        .getAllCategories();
    CategoryModel? category = existingCategories.firstWhere(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => CategoryModel(name: categoryName, color: ''),
    );

    // 2. Jika kategori baru, insert ke db
    if (category.id == null) {
      final newCatId = await categoryRepo.insertCategory(category);
      category = CategoryModel(id: newCatId, name: category.name, color: '');
    }

    // 3. Insert transaksi
    final trxId = await transactionRepo.insertTransaction(
      TransactionModel(
        title: name,
        amount: nominal,
        categoryId: category.id!,
        date: date,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transaksi berhasil ditambahkan: ID $trxId')),
    );

    // Debug print
    print("Nama: $name");
    print("Kategori: ${category.name} (ID: ${category.id})");
    print("Tanggal: $date");
    print("Nominal: $nominal");
    print("Transaction inserted: $trxId");

    // Clear form
    nameController.clear();
    nominalController.clear();
    selectedCategory = null;
    dateController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengeluaran Baru',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // name expense
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nama Pengeluaran',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // category expense
          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: ListCategoryData.categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          ListCategoryData.categoryColors[cat] ?? Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: CategoryIcon.categoryIcons[cat],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(cat),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                selectedCategory = val;
              });
            },
            decoration: InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                color: Color(0xFF828282),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // date expense
          TextField(
            controller: dateController,
            readOnly: true,
            onTap: _pickDate,
            decoration: InputDecoration(
              labelText: 'Tanggal Pengeluaran',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.grey),
                onPressed: _pickDate,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // price expense
          TextField(
            controller: nominalController,
            decoration: InputDecoration(
              labelText: 'Nominal',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),

          // button save
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveTransaction,
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
