//given a habit list of completion days
//is the habit completed today

import 'package:eudaimonia/models/habit.dart';

bool isHabitsCompletedToday(List<DateTime> completedDays){
  final today = DateTime.now();
  return completedDays.any((date) =>
    date.year == today.year &&
    date.month == today.month &&
    date.day == today.day,
   );
}

//prepare heatmap dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Filter out dates before the 1st of the current month
      if (normalizedDate.day >= 1) {
        // If present, increment the count
        if (dataset.containsKey(normalizedDate)) {
          dataset[normalizedDate] = dataset[normalizedDate]! + 1;
        } else {
          // Initialize it with count 1
          dataset[normalizedDate] = 1;
        }
      }
    }
  }

  return dataset;
}
