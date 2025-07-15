import 'package:calendar_app/providers/data_provider.dart';
import 'package:calendar_app/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dayEvents = context.watch<DataProvider>().dayEvents;
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TableCalendar(
              focusedDay: context.watch<DataProvider>().focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(day, context.watch<DataProvider>().selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                context.read<DataProvider>().changeSelectedDay(selectedDay);
                context.read<DataProvider>().changeFocusedDay(focusedDay);
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Tasks for ${context.watch<DataProvider>().todayString}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dayEvents.length,
              itemBuilder: (context, index) => EventTile(context: context, index: index, dayEvents: dayEvents)
            ),
          )
        ],
      ),
    );
  }
}