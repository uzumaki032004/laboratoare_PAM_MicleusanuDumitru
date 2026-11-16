import '../../data/models/models.dart';

/// Filtrele disponibile pentru lista de lecții.
enum LessonFilter {
  all('All'),
  available('Available'),
  locked('Locked'),
  completed('Completed');

  const LessonFilter(this.label);

  final String label;

  bool matches(Lesson lesson) => switch (this) {
    LessonFilter.all => true,
    LessonFilter.available => !lesson.locked,
    LessonFilter.locked => lesson.locked,
    LessonFilter.completed => lesson.completed,
  };
}

/// Variantele de sortare pentru lista de lecții.
enum LessonSort {
  courseOrder('Course order'),
  durationAsc('Shortest first'),
  durationDesc('Longest first'),
  titleAsc('Title A-Z');

  const LessonSort(this.label);

  final String label;
}

/// Funcție pură: aplică pe rând căutarea, filtrul și sortarea.
/// Fiind separată de Cubit, poate fi testată ușor.
List<Lesson> applyLessonQuery(
  List<Lesson> lessons, {
  String query = '',
  LessonFilter filter = LessonFilter.all,
  LessonSort sort = LessonSort.courseOrder,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  final result = lessons.where((lesson) {
    final matchesQuery =
        normalizedQuery.isEmpty ||
        lesson.title.toLowerCase().contains(normalizedQuery);
    return matchesQuery && filter.matches(lesson);
  }).toList();

  switch (sort) {
    case LessonSort.courseOrder:
      break;
    case LessonSort.durationAsc:
      result.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    case LessonSort.durationDesc:
      result.sort((a, b) => b.durationSeconds.compareTo(a.durationSeconds));
    case LessonSort.titleAsc:
      result.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
  }
  return List.unmodifiable(result);
}
