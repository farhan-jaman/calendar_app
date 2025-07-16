import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/widgets/calendar_widget.dart';
import 'package:calendar_app/widgets/event_tab.dart';
import 'package:calendar_app/widgets/task_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _datePicker(context),
          child: Text(DateFormat('MMMM y').format(context.watch<EventProvider>().focusedDay)),
        ),
        actions: [
          !context.watch<EventProvider>().hideBackButton
          ?
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () {
                  context.read<EventProvider>().changeSelectedDay(DateTime.now());
                  context.read<EventProvider>().changeFocusedDay(DateTime.now());
                },
                child: Text('Back to Today'),
              ),
            )
          :
            SizedBox()
        ],
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarWidget(),
            Expanded(
              child: TabBarView(
                children: [
                  EventTab(),
                  TaskTab(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _datePicker(BuildContext context) async {
  final picked = await showDatePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime(DateTime.now().year + 100),
    initialDate: context.read<EventProvider>().selectedDay,
    keyboardType: TextInputType.datetime,
    initialEntryMode: DatePickerEntryMode.calendar,
  );

  if (context.mounted && picked != null) {
    context.read<EventProvider>().changeSelectedDay(picked);
    context.read<EventProvider>().changeFocusedDay(picked);
  }
}