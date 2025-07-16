import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final Event event;
  const ConfirmDeleteDialog({super.key, required this.event});

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
            context.read<EventProvider>().deleteEvent(event);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}