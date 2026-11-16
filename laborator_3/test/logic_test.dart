import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app_lab3/logic/favorites/favorites_cubit.dart';
import 'package:learning_app_lab3/logic/home/home_cubit.dart';
import 'package:learning_app_lab3/logic/home/home_state.dart';
import 'package:learning_app_lab3/logic/lessons/lesson_query.dart';
import 'package:learning_app_lab3/logic/lessons/lessons_cubit.dart';
import 'package:learning_app_lab3/logic/lessons/lessons_state.dart';

import 'helpers/test_data.dart';

void main() {
  group('applyLessonQuery', () {
    final lessons = loadTestData().courseOverview.course.lessons;

    test('caută după titlu, fără diferență între litere mari și mici', () {
      final result = applyLessonQuery(lessons, query: 'build');
      expect(result.map((l) => l.id), ['lesson-4']);
    });

    test('filtrează lecțiile blocate și pe cele disponibile', () {
      expect(
        applyLessonQuery(lessons, filter: LessonFilter.locked),
        hasLength(1),
      );
      expect(
        applyLessonQuery(lessons, filter: LessonFilter.available),
        hasLength(3),
      );
    });

    test('sortează după durată și după titlu', () {
      final shortest = applyLessonQuery(lessons, sort: LessonSort.durationAsc);
      expect(shortest.first.id, 'lesson-1');
      final longest = applyLessonQuery(lessons, sort: LessonSort.durationDesc);
      expect(longest.first.id, 'lesson-3');
      final byTitle = applyLessonQuery(lessons, sort: LessonSort.titleAsc);
      expect(byTitle.first.title, 'Build React');
    });
  });

  group('HomeCubit', () {
    test('Loading -> Success după încărcare', () async {
      final cubit = HomeCubit(FakeLearningRepository());
      expect(cubit.state, isA<HomeLoading>());
      await cubit.load();
      expect(cubit.state, isA<HomeSuccess>());
      await cubit.close();
    });

    test('Error când repository-ul eșuează', () async {
      final cubit = HomeCubit(FailingLearningRepository());
      await cubit.load();
      expect(cubit.state, isA<HomeError>());
      await cubit.close();
    });
  });

  group('LessonsCubit', () {
    late LessonsCubit cubit;

    setUp(() async {
      cubit = LessonsCubit(FakeLearningRepository());
      await cubit.load();
    });

    tearDown(() => cubit.close());

    test('încarcă lecțiile și tab-ul selectat din JSON', () {
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.visibleLessons, hasLength(4));
      expect(cubit.state.selectedTabId, 'lessons');
    });

    test('căutarea fără rezultate produce starea Empty', () {
      cubit.search('kotlin');
      expect(cubit.state.status, LoadStatus.empty);
      cubit.search('');
      expect(cubit.state.status, LoadStatus.success);
    });

    test('Enroll deblochează lecțiile', () {
      cubit.enroll();
      expect(cubit.state.enrolled, isTrue);
      expect(cubit.state.lessons.where((l) => l.locked), isEmpty);
    });

    test('lecția blocată nu poate fi finalizată', () {
      cubit.toggleCompleted('lesson-4');
      expect(cubit.state.lessonById('lesson-4')!.completed, isFalse);
      cubit.toggleCompleted('lesson-1');
      expect(cubit.state.lessonById('lesson-1')!.completed, isTrue);
      expect(cubit.state.completedCount, 1);
    });

    test('simularea erorii produce starea Error cu mesaj', () async {
      await cubit.load(simulateError: true);
      expect(cubit.state.status, LoadStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
    });
  });

  test('FavoritesCubit adaugă și elimină favorite', () {
    final cubit = FavoritesCubit();
    cubit.toggle('lesson-1');
    expect(cubit.isFavorite('lesson-1'), isTrue);
    cubit.toggle('lesson-1');
    expect(cubit.state, isEmpty);
    cubit.close();
  });
}
