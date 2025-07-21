import 'package:calendar_app/pages/home_page.dart';
import 'package:calendar_app/providers/calendar_provider.dart';
import 'package:calendar_app/providers/data_provider.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        fontFamily: 'Poppins'
      ),
      home: HomePage(),
    );
  }
}