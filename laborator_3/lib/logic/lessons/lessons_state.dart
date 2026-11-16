import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import 'lesson_query.dart';

/// Cele patru stări principale ale listei.
enum LoadStatus { loading, success, empty, error }

/// Starea paginii cursului. Pe lângă status, păstrează căutarea, filtrul,
/// sortarea și tab-ul selectat, ca acestea să nu se piardă între reîncărcări.
class LessonsState extends Equatable {
  const LessonsState({
    this.status = LoadStatus.loading,
    this.overview,
    this.lessons = const [],
    this.visibleLessons = const [],
    this.query = '',
    this.filter = LessonFilter.all,
    this.sort = LessonSort.courseOrder,
    this.selectedTabId = 'lessons',
    this.enrolled = false,
    this.errorMessage,
  });

  final LoadStatus status;

  /// Datele cursului din JSON; `null` până la prima încărcare reușită.
  final CourseOverview? overview;

  /// Toate lecțiile, cu modificările utilizatorului (finalizat / deblocat).
  final List<Lesson> lessons;

  /// Lecțiile după căutare, filtrare și sortare.
  final List<Lesson> visibleLessons;
  final String query;
  final LessonFilter filter;
  final LessonSort sort;
  final String selectedTabId;
  final bool enrolled;
  final String? errorMessage;

  bool get hasData => overview != null;

  int get completedCount => lessons.where((lesson) => lesson.completed).length;

  int get visibleDurationSeconds =>
      visibleLessons.fold<int>(0, (sum, lesson) => sum + lesson.durationSeconds);

  Lesson? lessonById(String id) {
    for (final lesson in lessons) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  int indexOf(String id) => lessons.indexWhere((lesson) => lesson.id == id);

  /// `errorMessage` nu se copiază: mesajul există doar în starea Error.
  LessonsState copyWith({
    LoadStatus? status,
    CourseOverview? overview,
    List<Lesson>? lessons,
    List<Lesson>? visibleLessons,
    String? query,
    LessonFilter? filter,
    LessonSort? sort,
    String? selectedTabId,
    bool? enrolled,
    String? errorMessage,
  }) => LessonsState(
    status: status ?? this.status,
    overview: overview ?? this.overview,
    lessons: lessons ?? this.lessons,
    visibleLessons: visibleLessons ?? this.visibleLessons,
    query: query ?? this.query,
    filter: filter ?? this.filter,
    sort: sort ?? this.sort,
    selectedTabId: selectedTabId ?? this.selectedTabId,
    enrolled: enrolled ?? this.enrolled,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    overview,
    lessons,
    visibleLessons,
    query,
    filter,
    sort,
    selectedTabId,
    enrolled,
    errorMessage,
  ];
}
