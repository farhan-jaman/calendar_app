import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final int index;
  final Task task;
  const TaskTile({
    super.key,
    required this.index,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          context.read<TaskProvider>().editTask(index, Task(title: task.title, isComplete: !task.isComplete));
        },
        icon: Icon(
          task.isComplete ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded
        ),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          color: task.isComplete ? Colors.grey : Colors.black,
          fontSize: 14,
          decoration: task.isComplete ? TextDecoration.lineThrough : TextDecoration.none,
          decorationThickness: 1.5,
          decorationColor: Colors.grey,
        ),
      ),
    );
  }
}