import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bạn có chắc chắn muốn thoát?'),
      actions: [
        TextButton(
          child: const Text('Không'),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: const Text('Có'),
          onPressed: () => SystemNavigator.pop(),
        ),
      ],
    );
  }
}
