/// Formatează o durată în secunde: `45s`, `54min`, `1h 21min`.
String formatSeconds(int totalSeconds) {
  if (totalSeconds < 60) return '${totalSeconds}s';
  final minutes = totalSeconds ~/ 60;
  if (minutes < 60) return '${minutes}min';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0 ? '${hours}h' : '${hours}h ${rest}min';
}

/// Numărul lecției cu două cifre: `01`, `02`...
String lessonNumber(int index) => (index + 1).toString().padLeft(2, '0');
