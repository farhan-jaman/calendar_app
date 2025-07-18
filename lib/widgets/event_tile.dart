import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:calendar_app/widgets/dialogs/edit_event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(dayEvents[index].title),
        subtitle: Text(
          DateFormat('MMMM d, y').format(context.watch<EventProvider>().selectedDay)
        ),
        trailing: (!dayEvents[index].isHoliday)
        ?
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => EditEvent(event: dayEvents[index], index: index),
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