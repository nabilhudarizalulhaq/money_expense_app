import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;

  const SuccessPopup({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Berhasil',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
