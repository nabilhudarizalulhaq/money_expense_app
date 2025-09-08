import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/core/data/datasources/local_database.dart';
import 'package:money_expense/core/data/models/models.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/persentation/add%20new%20expe/widget/bottomsheet/bottomsheet.dart';
import 'package:money_expense/persentation/add%20new%20expe/widget/success_popup.dart';
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
  final TextEditingController categoryController = TextEditingController();
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    nominalController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  String formatDateIndo(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  // Pick date
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = formatDateIndo(picked);
      });
    }
  }

  // Show category bottom sheet
  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BottomSheetCategory(
        selectedCategory: selectedCategory,
        onSelected: (cat) {
          setState(() {
            selectedCategory = cat;
            categoryController.text = cat;
          });
        },
      ),
    );
  }

  // Save transaction
  Future<void> _saveTransaction() async {
    final name = nameController.text.trim();
    final categoryName = selectedCategory?.trim() ?? '';
    final date = selectedDate ?? DateTime.now();
    final nominalText = nominalController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final nominal = double.tryParse(nominalText) ?? 0;

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

    // 2. kategori baru, insert ke db
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

    showDialog(
      context: context,
      builder: (context) =>
          SuccessPopup(message: 'Data berhasil disimpan! $trxId'),
    );

    // Clear form
    nameController.clear();
    nominalController.clear();
    selectedCategory = null;
    categoryController.clear();
    dateController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengeluaran Baru',
          style: TextStyle(
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name expense
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nama Pengeluaran',
              labelStyle: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              hintText: null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category expense (read-only + bottom sheet)
          TextField(
            controller: categoryController,
            readOnly: true,

            onTap: _showCategorySheet,
            decoration: InputDecoration(
              labelText: 'Kategori',
              labelStyle: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              hintText: null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              // Icon
              prefixIcon: selectedCategory != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          ListCategoryData.categoryColors[selectedCategory!] ??
                              Colors.grey,
                          BlendMode.srcIn,
                        ),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CategoryIcon.categoryIcons[selectedCategory!],
                        ),
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              // Icon next bbottom sheet
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE0E0E0),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: Color(0xFF828282),
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date expense
          TextField(
            controller: dateController,
            readOnly: true,
            onTap: _pickDate,
            decoration: InputDecoration(
              labelText: 'Tanggal Pengeluaran',
              labelStyle: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              hintText: null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: _pickDate,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Price expense
          TextField(
            controller: nominalController,
            decoration: InputDecoration(
              labelText: 'Nominal',
              labelStyle: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),

          // Button save
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
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
