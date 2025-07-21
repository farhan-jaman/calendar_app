import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];
  final _taskService = TaskService();

  List<Task> get taskList => _taskList;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _taskList = await _taskService.loadTaskList();
    notifyListeners();
  }

  void addTask(Task newTask) {
    _taskList.add(newTask);
    _taskService.saveTaskList(_taskList);
    notifyListeners();
  }

  void editTask(int index, Task newTask) {
    _taskList[index] = newTask;
    _taskService.saveTaskList(_taskList);
    notifyListeners();
  }

  void editAllTass(List<Task> newTaskList) {
    _taskList = newTaskList;
    _taskService.saveTaskList(_taskList);
    notifyListeners();
  }

  void deleteAllTasks() {
    _taskList = [];
    _taskService.saveTaskList(_taskList);
    notifyListeners();
  }
}