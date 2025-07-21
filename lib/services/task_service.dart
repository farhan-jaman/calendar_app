import 'dart:convert';
import 'package:calendar_app/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<void> saveTaskList(List<Task> taskList) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('task_list', taskList.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<List<Task>> loadTaskList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList('task_list');

    if (jsonStringList == null) return [];

    return jsonStringList.map((e) => Task.fromJson(jsonDecode(e))).toList();
  }
}