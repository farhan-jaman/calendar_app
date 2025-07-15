import 'package:calendar_app/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEvent extends StatelessWidget {
  const EditEvent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: Text('Event Name'),
      content: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
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
            context.read<DataProvider>().addEvent(controller.text);
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}