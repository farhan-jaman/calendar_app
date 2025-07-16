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
        focusedDay: context.watch<EventProvider>().focusedDay,
        firstDay: DateTime(DateTime.now().year - 100),
        lastDay: DateTime(DateTime.now().year + 100),
        startingDayOfWeek: StartingDayOfWeek.sunday,
        weekendDays: [DateTime.friday, DateTime.saturday],
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.red),
        ),
        selectedDayPredicate: (day) => isSameDay(day, context.watch<EventProvider>().selectedDay),
        onDaySelected: (selectedDay, focusedDay) {
          context.read<EventProvider>().changeFocusedDay(focusedDay);
          context.read<EventProvider>().changeSelectedDay(selectedDay);
        },
        onPageChanged: (focusedDay) => context.read<EventProvider>().changeFocusedDay(focusedDay),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final holidays = context.watch<EventProvider>().holidays;
            final isHoliday = holidays.containsKey(DateTime(day.year, day.month, day.day));

            if (isHoliday) {
              return Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.flag_rounded, size: 14, color: Colors.teal,),
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
          weekendTextStyle: TextStyle(color: Colors.red)
        ),
      ),
    );
  }
}