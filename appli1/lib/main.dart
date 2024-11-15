import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'components/HabitTrackerPage.dart';

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

class Habit {
  final String title;
  DateTime? startDate;
  Set<DateTime> completedDays = {}; // Ensemble de jours sélectionnés

  Habit({required this.title});

  int get daysSinceStart => completedDays.length; // Compte les jours accomplis

  void start() {
    startDate = DateTime.now();
  }

  void reset() {
    startDate = null;
    completedDays.clear();
  }

  void toggleDayCompletion(DateTime day) {
    if (completedDays.contains(day)) {
      completedDays.remove(day);
    } else {
      completedDays.add(day);
    }
  }

  bool isDayCompleted(DateTime day) {
    return completedDays.contains(day);
  }

  void selectAllDaysInMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    for (int day = 1; day <= daysInMonth; day++) {
      completedDays.add(DateTime(year, month, day));
    }
  }
}

class HabitTrackerProvider extends ChangeNotifier {
  List<Habit> habits = [
    Habit(title: "Ne pas fumer"), // Habitude par défaut
  ];

  void addHabit(String title) {
    habits.add(Habit(title: title));
    notifyListeners();
  }

  void removeHabit(int index) {
    habits.removeAt(index);
    notifyListeners();
  }
}



class HabitProgressPage extends StatefulWidget {
  final Habit habit;

  HabitProgressPage({required this.habit});

  @override
  _HabitProgressPageState createState() => _HabitProgressPageState();
}

class _HabitProgressPageState extends State<HabitProgressPage> {
  late Timer timer;
  int currentMonth = DateTime.now().month; // Mois actuel pour l'affichage

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Met à jour l'affichage toutes les secondes
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Arrête le timer lorsque la page est fermée
    super.dispose();
  }

  void goToPreviousMonth() {
    setState(() {
      if (currentMonth > 1) {
        currentMonth--;
      }
    });
  }

  void goToNextMonth() {
    setState(() {
      if (currentMonth < 12) {
        currentMonth++;
      }
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
                    TextButton(
                      onPressed: selectAllDaysInMonth,
                      child: Text('Select All Days'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white, // Texte en blanc
                        textStyle: TextStyle(fontSize: 14),
                        minimumSize: Size(0, 0), // Supprime les marges par défaut
                      ),
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
