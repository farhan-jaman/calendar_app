import 'dart:convert';
import 'package:calendar_app/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  Future<void> saveEventList(List<Event> eventList) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> jsonList = eventList.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList('event_list', jsonList);
  }

  Future<List<Event>> loadEventList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList('event_list');

    if (jsonStringList == null) return [];

    return jsonStringList.map((e) => Event.fromJson(jsonDecode(e))).toList();
  }
}