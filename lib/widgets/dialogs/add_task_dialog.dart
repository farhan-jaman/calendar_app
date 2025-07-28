import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    return AlertDialog(
      title: Text('Task'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 100,
        onSubmitted: (value) {
          context.read<TaskProvider>().addTask(Task(title: value, day: DateTime.now()));
          Navigator.pop(context);
        },
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
            context.read<TaskProvider>().addTask(Task(
              title: controller.text,
              day: DateTime.now(),
            ));
            controller.dispose();
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}