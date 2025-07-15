import 'package:calendar_app/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final int index;
  const ConfirmDeleteDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<DataProvider>().deleteEvent(index);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}