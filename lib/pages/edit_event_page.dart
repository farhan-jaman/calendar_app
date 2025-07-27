import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/providers/calendar_provider.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/widgets/dialogs/time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatefulWidget {

  final Event? event;
  final int? index;

  const EditEventPage({
    super.key,
    this.event,
    this.index,
  });

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  late bool _isEditing;
  late TextEditingController _titleController;
  late CalendarProvider _calendarProvider;

  late String _title;
  late bool _allDay;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _isEditing = (widget.index != null) && (widget.event != null);
    _titleController = TextEditingController();

    _title = widget.event?.title ?? '';
    _allDay = widget.event?.isAllDay ?? false;

    _titleController.text = _title;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _calendarProvider = Provider.of<CalendarProvider>(context);
    _startTime = widget.event?.startTime ?? DateTime(
      _calendarProvider.selectedDay.year,
      _calendarProvider.selectedDay.month,
      _calendarProvider.selectedDay.day,
      7,
      30,
    );
    _endTime = _startTime.add(Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                _isEditing
                ?
                  context.read<EventProvider>().editEvent(
                    widget.index!,
                    Event(
                      title: _titleController.text,
                      isAllDay: _allDay,
                      startTime: _startTime,
                      endTime: _endTime,
                    ),
                    widget.event!,
                  )
                :
                  context.read<EventProvider>().addEvent(
                    Event(
                      title: _titleController.text,
                      isAllDay: _allDay,
                      startTime: _startTime,
                      endTime: _endTime,
                    ),
                  );
                Navigator.pop(context);
              },
              icon: Icon(Icons.check_rounded),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing
              ?
                'Edit Event'
              :
                'Add Event',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),

            // E V E N T    D E T A I L S
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Event name',
              ),
            ),
            SizedBox(height: 12),

            SwitchListTile.adaptive(
              title: Text('All day'),
              value: _allDay,
              onChanged: (value) {
                setState(() {
                  _allDay = value;
                });
              },
            ),
            SizedBox(height: 12),

            ListTile(
              onTap: () {
                if (_allDay) return;
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) => TimePicker(
                    isFrom: true,
                    onValueSelected: (time) => setState(() => _startTime = time),
                    time: _startTime,
                  ),
                );
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('From'),
                  Text(
                    _allDay
                    ?
                      'All day'
                    :
                      '${DateFormat('E, dd MMM yyyy HH:mm').format(_startTime)}    >',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            ListTile(
              onTap: () {
                if (_allDay) return;
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) => TimePicker(
                    isFrom: false,
                    onValueSelected: (time) {
                      if (time.isBefore(_startTime)) {
                        setState(() {
                          _endTime = _startTime.add(Duration(hours: 1));
                        });
                      } else {
                        setState(() {
                          _endTime = time;
                        });
                      }
                    },
                    time: _endTime,
                  ),
                );
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('To'),
                  Text(
                    _allDay
                    ?
                      'All day'
                    :
                      '${DateFormat('E, dd MMM yyyy HH:mm').format(_endTime)}    >',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}