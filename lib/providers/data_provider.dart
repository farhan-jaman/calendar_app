import 'package:calendar_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataProvider extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<Event>> _events = {};

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  Map<DateTime, List<Event>> get events => _events;
  List<Event> get dayEvents => _events[normalizedDate(_selectedDay)] ?? [];
  DateTime get selectedKey => _events.entries.firstWhere((element) => element.value == dayEvents).key;
  String get todayString => normalizedDate(_selectedDay) == normalizedDate(DateTime.now()) ? 'Today' : DateFormat('d MMMM').format(_selectedDay);

  void changeFocusedDay(DateTime newDay) {
    _focusedDay = newDay;
    notifyListeners();
  }

  void changeSelectedDay(DateTime newDay) {
    _selectedDay = newDay;
    notifyListeners();
  }

  void addEvent(String title) {
    DateTime key = normalizedDate(_selectedDay);

    if (_events.containsKey(key)) {
      _events[key]!.add(Event(title: title));
    } else {
      _events[key] = [Event(title: title)];
    }
    notifyListeners();
  }

  void editEvent(int index, String title) {
    DateTime key = normalizedDate(_selectedDay);

    _events[key]![index].title = title;
    notifyListeners();
  }

  void deleteEvent(int index) {
    DateTime key = normalizedDate(_selectedDay);

    _events[key]!.removeAt(index);

    if (_events[key]!.isEmpty) _events.remove(key);
    notifyListeners();
  }

  DateTime normalizedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}