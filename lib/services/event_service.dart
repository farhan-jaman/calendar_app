import 'dart:convert';
import 'package:calendar_app/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  Future<void> saveEventMap(Map<DateTime, List<Event>> eventMap) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonMap = {
      for (var entry in eventMap.entries)
        entry.key.toIso8601String(): entry.value.map((e) => e.toJson()).toList()
    };

    await prefs.setString('event_map', jsonEncode(jsonMap));
  }

  Future<Map<DateTime, List<Event>>> loadEventMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('event_map');

    if (jsonString == null) return {};

    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    return {
      for (var entry in decoded.entries)
        DateTime.parse(entry.key): (entry.value as List)
        .map((e) => Event.fromJson(e))
        .toList()
    };
  }
}