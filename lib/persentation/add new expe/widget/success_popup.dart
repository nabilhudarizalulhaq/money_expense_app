import 'package:flutter/material.dart';

Future<void> showSuccessPopup({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Success",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox.shrink(); // Not used, actual UI in transitionBuilder
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    },
  );
}
