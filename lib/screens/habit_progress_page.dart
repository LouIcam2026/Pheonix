// screens/habit_progress_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/custom_button.dart';

class HabitProgressPage extends StatefulWidget {
  final Habit habit;

  HabitProgressPage({required this.habit});

  @override
  _HabitProgressPageState createState() => _HabitProgressPageState();
}

class _HabitProgressPageState extends State<HabitProgressPage> {
  late Timer timer;
  int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void goToPreviousMonth() {
    setState(() {
      if (currentMonth > 1) currentMonth--;
    });
  }

  void goToNextMonth() {
    setState(() {
      if (currentMonth < 12) currentMonth++;
    });
  }

  void selectAllDaysInMonth() {
    setState(() {
      widget.habit.selectAllDaysInMonth(DateTime.now().year, currentMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                '${widget.habit.daysSinceStart} Days',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: goToPreviousMonth,
                  color: Colors.deepPurple,
                ),
                Column(
                  children: [
                    Text(
                      getMonthName(currentMonth),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    CustomButton(
                      text: 'Select All Days',
                      onPressed: selectAllDaysInMonth,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: goToNextMonth,
                  color: Colors.deepPurple,
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: buildMonthCalendar(context, currentMonth),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMonthCalendar(BuildContext context, int month) {
    int daysInMonth = DateTime(DateTime.now().year, month + 1, 0).day;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(daysInMonth, (dayIndex) {
        DateTime day = DateTime(DateTime.now().year, month, dayIndex + 1);
        bool isCompleted = widget.habit.isDayCompleted(day);

        return GestureDetector(
          onTap: () {
            setState(() {
              widget.habit.toggleDayCompletion(day);
            });
          },
          child: CircleAvatar(
            radius: 10,
            backgroundColor: isCompleted ? Colors.deepPurple : Colors.grey[300],
          ),
        );
      }),
    );
  }

  String getMonthName(int month) {
    List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}
