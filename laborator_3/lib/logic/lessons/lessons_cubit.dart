import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/learning_repository.dart';
import '../error_message.dart';
import 'lesson_query.dart';
import 'lessons_state.dart';

/// Gestionează pagina cursului: încărcare, căutare, filtrare, sortare,
/// tab-uri, înscriere și marcarea lecțiilor ca finalizate.
class LessonsCubit extends Cubit<LessonsState> {
  LessonsCubit(this._repository) : super(const LessonsState());

  final LearningRepository _repository;

  Future<void> load({bool refresh = false, bool simulateError = false}) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final data = await _repository.loadData(
        forceRefresh: refresh,
        simulateError: simulateError,
      );
      if (isClosed) return;
      final overview = data.courseOverview;
      emit(
        _withVisibleLessons(
          state.copyWith(
            overview: overview,
            lessons: overview.course.lessons,
            enrolled: false,
            selectedTabId: state.hasData
                ? state.selectedTabId
                : overview.course.selectedTabId,
          ),
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: LoadStatus.error,
          errorMessage: describeError(error),
        ),
      );
    }
  }

  void search(String query) {
    if (!state.hasData) return;
    emit(_withVisibleLessons(state.copyWith(query: query)));
  }

  void setFilter(LessonFilter filter) {
    if (!state.hasData) return;
    emit(_withVisibleLessons(state.copyWith(filter: filter)));
  }

  void setSort(LessonSort sort) {
    if (!state.hasData) return;
    emit(_withVisibleLessons(state.copyWith(sort: sort)));
  }

  void selectTab(String tabId) {
    if (!state.hasData) return;
    emit(state.copyWith(selectedTabId: tabId));
  }

  /// „Enroll Now”: deblochează toate lecțiile.
  void enroll() {
    if (!state.hasData || state.enrolled) return;
    final unlocked = [
      for (final lesson in state.lessons) lesson.copyWith(locked: false),
    ];
    emit(
      _withVisibleLessons(state.copyWith(enrolled: true, lessons: unlocked)),
    );
  }

  /// Marchează / demarchează o lecție ca finalizată (doar dacă nu e blocată).
  void toggleCompleted(String lessonId) {
    final lesson = state.lessonById(lessonId);
    if (lesson == null || lesson.locked) return;
    final updated = [
      for (final item in state.lessons)
        item.id == lessonId ? item.copyWith(completed: !item.completed) : item,
    ];
    emit(_withVisibleLessons(state.copyWith(lessons: updated)));
  }

  /// Recalculează lista vizibilă și alege între Success și Empty.
  LessonsState _withVisibleLessons(LessonsState next) {
    final List<Lesson> visible = applyLessonQuery(
      next.lessons,
      query: next.query,
      filter: next.filter,
      sort: next.sort,
    );
    return next.copyWith(
      visibleLessons: visible,
      status: visible.isEmpty ? LoadStatus.empty : LoadStatus.success,
    );
  }
}
