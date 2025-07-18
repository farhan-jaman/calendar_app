import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/services/event_service.dart';
import 'package:calendar_app/services/holiday_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService = EventService();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> _events = {};
  final Map<DateTime, List<Event>> _holidays = {};

  DateTime get focusedDay => normalizedDate(_focusedDay);
  DateTime get selectedDay => normalizedDate(_selectedDay);
  Map<DateTime, List<Event>> get events => _events;
  Map<DateTime, List<Event>> get holidays => _holidays;
  bool get hideBackButton => checkFocusedDay(_focusedDay) && isSameDay(_selectedDay, DateTime.now());
  List<Event> get dayEvents {
    final selectedDate = normalizedDate(_selectedDay);

    final userEvents = _events[selectedDate] ?? [];
    final holidayEvents = _holidays[selectedDate] ?? [];

    return [...holidayEvents, ...userEvents];
  }
  String get todayString => normalizedDate(_selectedDay) == normalizedDate(DateTime.now()) ? 'Today' : DateFormat('d MMMM').format(_selectedDay);

  EventProvider() {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    _events = await _eventService.loadEventMap();
  }

  void changeFocusedDay(DateTime newDay) {
    _focusedDay = normalizedDate(newDay);
    _chechAndLoadHolidayForYear(newDay.year);
    notifyListeners();
  }

  void changeSelectedDay(DateTime newDay) {
    _selectedDay = normalizedDate(newDay);
    notifyListeners();
  }

  // A D D    E V E N T
  void addEvent(String title) {
    DateTime key = normalizedDate(_selectedDay);

    if (_events.containsKey(key)) {
      _events[key]!.add(Event(title: title));
    } else {
      _events[key] = [Event(title: title)];
    }
    _eventService.saveEventMap(_events);
    notifyListeners();
  }

  // E D I T    E V E N T
  void editEvent(int index, String title) {
    DateTime key = normalizedDate(_selectedDay);

    _events[key]![index].title = title;
    _eventService.saveEventMap(_events);
    notifyListeners();
  }

  // D E L E T E    E V E N T
  void deleteEvent(Event event) {
    DateTime key = normalizedDate(_selectedDay);

    _events[key]!.remove(event);

    if (_events[key]!.isEmpty) _events.remove(key);

    _eventService.saveEventMap(_events);
    notifyListeners();
  }

  Future<void> _chechAndLoadHolidayForYear(int year) async {
    final alreadyLoaded = _holidays.keys.any((d) => d.year == year);
    if (!alreadyLoaded) {
      final newHolidays = await HolidayService.loadHolidays(year);
      _holidays.addAll(newHolidays);
      notifyListeners();
    }
  }


  DateTime normalizedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool checkFocusedDay(DateTime focusedDay) {
    final today = DateTime.now();
    return (focusedDay.year == today.year && focusedDay.month == today.month);
  }
}