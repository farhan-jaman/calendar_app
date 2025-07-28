import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/pages/edit_event_page.dart';
import 'package:calendar_app/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {

  final BuildContext context;
  final int index;
  final List<Event> dayEvents;

  const EventTile({
    super.key,
    required this.context,
    required this.index,
    required this.dayEvents,
  });

  @override
  Widget build(BuildContext context) {
    final startHour = dayEvents[index].startTime.hour.toString().padLeft(2, '0');
    final startMin = dayEvents[index].startTime.minute.toString().padLeft(2, '0');

    final endHour = dayEvents[index].endTime.hour.toString().padLeft(2, '0');
    final endMin = dayEvents[index].endTime.minute.toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(dayEvents[index].title),
        subtitle: Text(
          dayEvents[index].isAllDay
          ?
            'All day'
          :
            '$startHour:$startMin - $endHour:$endMin',
        ),
        trailing: (!dayEvents[index].isHoliday)
        ?
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => EditEventPage(event: dayEvents[index], index: index),
                ),
                child: Text('Edit'),
              ),
              PopupMenuItem(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ConfirmDeleteDialog(event: dayEvents[index]),
                ),
                child: Text('Delete'),
              ),
            ],
          )
        :
          SizedBox(),
        tileColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}