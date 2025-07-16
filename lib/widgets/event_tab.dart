import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventTab extends StatelessWidget {
  const EventTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dayEvents = context.watch<EventProvider>().dayEvents;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: dayEvents.isEmpty
      ? 
        Center(
          child: Text('Events'),
        )
      :
        ListView.builder(
          itemCount: dayEvents.length,
          itemBuilder: (context, index) => EventTile(context: context, index: index, dayEvents: dayEvents),
        ),
    );
  }
}