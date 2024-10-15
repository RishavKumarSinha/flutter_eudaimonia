//given a habit list of completion days
//is the habit completed today?

bool isHabitCompletedToday(List<DateTime> completionDays) {
  final today = DateTime.now();
  return completionDays.any((day) => day.year == today.year && day.month == today.month && day.day == today.day);
}