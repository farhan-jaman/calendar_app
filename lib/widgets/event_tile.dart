import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/data_provider.dart';
import 'package:calendar_app/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventTile extends StatelessWidget {

  final BuildContext context;
  final int index;
  final List<Event> dayEvents;

  const EventTile({super.key, required this.context, required this.index, required this.dayEvents});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(dayEvents[index].title),
        subtitle: Text(
          DateFormat('MMMM d, y').format(context.watch<DataProvider>().selectedKey)
        ),
        trailing: IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ConfirmDeleteDialog(index: index),
          ),
          icon: Icon(Icons.delete_rounded),
        ),
        tileColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}