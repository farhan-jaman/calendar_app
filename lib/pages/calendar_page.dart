import 'package:calendar_app/providers/calendar_provider.dart';
import 'package:calendar_app/providers/data_provider.dart';
import 'package:calendar_app/widgets/calendar_widget.dart';
import 'package:calendar_app/widgets/event_tab.dart';
import 'package:calendar_app/widgets/task_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {

  late TabController _tabController;
  int? _lastNotifiedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tabController.animation?.addListener(() {
      final double animationValue = _tabController.animation!.value;
      final int targetIndex = animationValue.round();

      if ((animationValue - targetIndex).abs() < 0.5 && _lastNotifiedIndex != targetIndex && mounted) {
        _lastNotifiedIndex = targetIndex;
        context.read<DataProvider>().changeTabIndex(targetIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.withAlpha(180),
          title: GestureDetector(
            onTap: () => _datePicker(context),
            child: Text(DateFormat('MMMM y').format(context.watch<CalendarProvider>().focusedDay)),
          ),
          actions: [
            !context.watch<CalendarProvider>().hideBackButton
            ?
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: () {
                    context.read<CalendarProvider>().changeSelectedDay(DateTime.now());
                    context.read<CalendarProvider>().changeFocusedDay(DateTime.now());
                  },
                  child: Text('Back to Today'),
                ),
              )
            :
              SizedBox()
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarWidget(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  EventTab(selectedDay: context.watch<CalendarProvider>().selectedDay),
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
    initialDate: context.read<CalendarProvider>().selectedDay,
    keyboardType: TextInputType.datetime,
    initialEntryMode: DatePickerEntryMode.calendar,
  );

  if (context.mounted && picked != null) {
    context.read<CalendarProvider>().changeSelectedDay(picked);
    context.read<CalendarProvider>().changeFocusedDay(picked);
  }
}