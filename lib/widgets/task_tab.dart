import 'package:calendar_app/pages/task_page.dart';
import 'package:calendar_app/providers/task_provider.dart';
import 'package:calendar_app/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:calendar_app/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskTab extends StatelessWidget {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks for Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmDeleteDialog(),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TaskPage())
                          );
                        },
                        icon: Icon(Icons.edit_rounded),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: provider.taskList.length + 1,
                itemBuilder: (context, index) {
                  if (index == provider.taskList.length) {
                    return SizedBox(height: 24);
                  } else {
                    if (index == provider.incompleteTasks.length) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Completed  ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          TaskTile(
                            index: index,
                            task: provider.completedTasks[index - provider.incompleteTasks.length],
                          )
                        ],
                      );
                    }
                    if (index >= provider.incompleteTasks.length && provider.completedTasks.isNotEmpty) {
                      return TaskTile(
                        index: index,
                        task: provider.completedTasks[index - provider.incompleteTasks.length]
                      );
                    } else {
                      return TaskTile(index: index, task: provider.incompleteTasks[index]);
                    }
                  }
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}