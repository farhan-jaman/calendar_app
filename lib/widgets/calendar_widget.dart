import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/calendar_provider.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: TableCalendar(
        rowHeight: MediaQuery.of(context).size.height / 12,
        focusedDay: context.watch<CalendarProvider>().focusedDay,
        firstDay: DateTime(DateTime.now().year - 100),
        lastDay: DateTime(DateTime.now().year + 100),
        startingDayOfWeek: StartingDayOfWeek.sunday,
        selectedDayPredicate: (day) => isSameDay(day, context.watch<CalendarProvider>().selectedDay),
        onCalendarCreated: (_) {
          context.read<EventProvider>().loadEvents(context.read<CalendarProvider>().focusedDay.year);
        },
        onDaySelected: (selectedDay, focusedDay) {
          context.read<CalendarProvider>().changeFocusedDay(focusedDay);
          context.read<CalendarProvider>().changeSelectedDay(selectedDay);
        },
        onPageChanged: (focusedDay) => context.read<CalendarProvider>().changeFocusedDay(focusedDay),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final holidays = context.watch<EventProvider>().holidayList;
            final isHoliday = holidays.firstWhere((e) => day.isAfter(e.startTime) && day.isBefore(e.endTime), orElse: () => Event(title: '', startTime: DateTime(0), endTime: DateTime(0), isHoliday: false)).isHoliday;
            final hasEvent = context.watch<EventProvider>().hasEvent(day);

            if (isHoliday) {
              return Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.flag_rounded, size: 12, color: Colors.teal,),
              );
            }

            if (hasEvent) {
              return Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.event, size: 12, color: Colors.teal),
              );
            }
            return null;
          },
        ),
        headerVisible: false,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(400),
            shape: BoxShape.circle
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle
          ),
          todayTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          selectedTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}