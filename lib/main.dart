import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_tracker_provider.dart';
import 'screens/habit_tracker_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitTrackerProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HabitTrackerPage(),
      ),
    );
  }
}
