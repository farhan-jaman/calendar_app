import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final Event? event;
  const ConfirmDeleteDialog({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        event != null
        ?
          'Delete?'
        :
          'Delete all Tasks?'
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            event != null
            ?
              context.read<EventProvider>().removeEvent(event!)
            :
              context.read<TaskProvider>().deleteAllTasks();
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}