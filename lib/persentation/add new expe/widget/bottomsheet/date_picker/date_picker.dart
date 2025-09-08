// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

// class DatePicker extends StatefulWidget {
//   final TextEditingController controller;
//   final DateTime? initialDate;
//   final Function(DateTime)? onDateSelected;

//   const DatePicker({
//     super.key,
//     required this.controller,
//     this.initialDate,
//     this.onDateSelected,
//   });

//   @override
//   State<DatePicker> createState() => _DatePickerState();
// }

// class _DatePickerState extends State<DatePicker> {
//   DateTime? selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('id_ID', null);
//     selectedDate = widget.initialDate;
//   }

//   String formatDateIndo(DateTime date) {
//     return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
//   }

//   Future<void> _pickDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//         widget.controller.text = formatDateIndo(picked);
//       });

//       if (widget.onDateSelected != null) {
//         widget.onDateSelected!(picked);
//       }
//     }
//   }

  