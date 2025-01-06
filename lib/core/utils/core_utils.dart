import 'package:available/core/enums/snack_bar_type.dart';
import 'package:flutter/material.dart';

sealed class CoreUtils {
  static void showSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    SnackBarType type = SnackBarType.error,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(type.icon, color: type.colour, size: 15),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(message, style: const TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: type.colour,
        ),
      );
  }

  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    bool important = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 41),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: important ? Colors.red : null,
                minimumSize: const Size(0, 41),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
