import 'package:flutter/material.dart';

class ConfirmDiscardDialog extends StatelessWidget {
  const ConfirmDiscardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Discard changes?'),
      content: Text('You have unsaved changes. Do you really want to discard them?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Discard'),
        ),
      ],
    );
  }
}