import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatelessWidget {
  final Event? event;
  final int? index;
  const EditEvent({
    super.key,
    this.event,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final isEditing = event != null;
    if (isEditing) controller.text = event!.title;

    return AlertDialog(
      title: Text('Event Name'),
      content: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.dispose();
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            (isEditing)
            ?
              context.read<EventProvider>().editEvent(index!, controller.text)
            :
              context.read<EventProvider>().addEvent(controller.text);
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}