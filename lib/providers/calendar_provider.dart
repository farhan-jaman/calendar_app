import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _focusedDay = normalizeDate(DateTime.now());
  DateTime _selectedDay = normalizeDate(DateTime.now());

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;

  bool get hideBackButton => checkedFocusedDay(_focusedDay) && isSameDay(_selectedDay, DateTime.now());

  void changeFocusedDay(DateTime newDay) {
    _focusedDay = normalizedDate(newDay);
    notifyListeners();
  }

  void changeSelectedDay(DateTime newDay) {
    _selectedDay = normalizeDate(newDay);
    notifyListeners();
  }

  bool checkedFocusedDay(DateTime focusedDay) {
    final today = DateTime.now();
    return (focusedDay.year == today.year && focusedDay.month == today.month);
  }

  DateTime normalizedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}