import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/services/event_service.dart';
import 'package:calendar_app/services/holiday_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventProvider extends ChangeNotifier {
  final _eventService = EventService();
  List<Event> _eventList = [];
  List<Event> _holidayList = [];

  List<Event> get eventList => _eventList;
  List<Event> get holidayList => _holidayList;

  Future loadEvents(int year) async {
    _eventList = await _eventService.loadEventList();
    _holidayList = await HolidayService.loadHolidays(year);
    notifyListeners();
  }

  List<Event> getTodayList(DateTime selectedDay) {
    final todayEventList = _eventList.where((element) => isInDay(selectedDay, element.startTime, element.endTime));
    final todayHolidayList = _holidayList.where((element) => isInDay(selectedDay, element.startTime, element.endTime));

    return [...todayHolidayList, ...todayEventList];
  }

  void addEvent(Event newEvent) {
    _eventList.add(newEvent);
    _eventService.saveEventList(_eventList);
    notifyListeners();
  }

  void editEvent(int index, Event newEvent, Event oldEvent) {
    _eventList[_eventList.indexOf(oldEvent)] = newEvent;
    _eventService.saveEventList(_eventList);
    notifyListeners();
  }

  void removeEvent(Event event, int index) {
    _eventList.remove(event);
    _eventService.saveEventList(_eventList);
    notifyListeners();
  }

  bool isInDay(DateTime selectedDay, DateTime after, DateTime before) {
    if (selectedDay.isAfter(after) && selectedDay.isBefore(before)) return true;

    if (isSameDay(selectedDay, before) || isSameDay(selectedDay, after)) return true;

    return false;
  }
}