// providers/habit_tracker_provider.dart
import 'package:flutter/material.dart';
import '../models/habit.dart';

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
