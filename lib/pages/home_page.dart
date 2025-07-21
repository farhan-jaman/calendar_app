import 'package:calendar_app/pages/calendar_page.dart';
import 'package:calendar_app/pages/edit_event_page.dart';
import 'package:calendar_app/providers/data_provider.dart';
import 'package:calendar_app/widgets/dialogs/add_task_dialog.dart';
import 'package:calendar_app/pages/events_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 1;
  final List<Widget> _pages = [
    EventsPage(),
    CalendarPage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.bookmark_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Calendar',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              switch (context.read<DataProvider>().tabIndex) {
                case 0: return EditEventPage();
                case 1: return AddTaskDialog();
                default: return EditEventPage();
              }
            },
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}