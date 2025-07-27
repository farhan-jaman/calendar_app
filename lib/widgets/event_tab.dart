import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventTab extends StatelessWidget {
  final DateTime selectedDay;
  const EventTab({
    super.key,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final dayEvents = context.watch<EventProvider>().getTodayList(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: dayEvents.isEmpty
      ? 
        Center(
          child: Text('Events'),
        )
      :
        ListView.builder(
          itemCount: dayEvents.length + 1,
          itemBuilder: (context, index) {
            if (index == dayEvents.length) {
              return SizedBox(height: 24);
            }
            return EventTile(context: context, index: index, dayEvents: dayEvents);
          }
        ),
    );
  }
}