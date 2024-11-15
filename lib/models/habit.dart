// models/habit.dart
class Habit {
  final String title;
  DateTime? startDate;
  Set<DateTime> completedDays = {};

  Habit({required this.title});

  int get daysSinceStart => completedDays.length;

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
