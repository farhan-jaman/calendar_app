import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];
  int? _focusIndex;
  final _taskService = TaskService();

  List<Task> get taskList => _taskList;
  List<Task> get incompleteTasks => _taskList.where((task) => !task.isComplete).toList();
  List<Task> get completedTasks => _taskList.where((task) => task.isComplete).toList();
  int? get focusIndex => _focusIndex;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _taskList = await _taskService.loadTaskList();
    notifyListeners();
  }

  void requestFocusAt(int index) {
    _focusIndex = index;
    notifyListeners();
  }

  void clearFocusIndex() {
    _focusIndex = null;
  }

  void addTask(Task newTask) {
    _taskList.add(newTask);
    _saveTasks();
  }

  void updateTask(Task oldTask, Task newTask) {
    _taskList[_taskList.indexOf(oldTask)] = newTask;
    _saveTasks();
  }

  void editAllTasks(List<Task> newTaskList) {
    _taskList = newTaskList;
    _saveTasks();
  }

  void addTaskAt(int index) {
    _taskList.insert(index + 1, Task(title: '', isComplete: false, day: DateTime.now()));
    _saveTasks();
  }

  void removeTaskAt(int index) {
    if (_taskList.length > 1) {
      _taskList.removeAt(index);
      _saveTasks();
    }
  }

  void deleteAllTasks() {
    _taskList.clear();
    _saveTasks();
  }

  void _saveTasks() {
    _taskService.saveTaskList(_taskList);
    notifyListeners();
  }
}