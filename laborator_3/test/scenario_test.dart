import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app_lab3/app.dart';
import 'package:learning_app_lab3/data/models/models.dart';
import 'package:learning_app_lab3/data/repositories/learning_repository.dart';
import 'package:learning_app_lab3/logic/lessons/lesson_query.dart';

import 'helpers/test_data.dart';

/// Repository cu o mică întârziere, ca starea Loading să poată fi observată.
class SlowLearningRepository extends FakeLearningRepository {
  @override
  Future<AppData> loadData({
    bool forceRefresh = false,
    bool simulateError = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return super.loadData(
      forceRefresh: forceRefresh,
      simulateError: simulateError,
    );
  }
}

/// Parcurge scenariul prezentării pe un ecran îngust (360 x 740).
/// Orice overflow de layout face testul să pice.
Future<void> pumpNarrow(
  WidgetTester tester,
  LearningRepository repository,
) async {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(LearningApp(repository: repository));
  await tester.pumpAndSettle();
}

/// Derulează lista principală până când elementul este vizibil.
Future<void> scrollTo(
  WidgetTester tester,
  Finder finder, {
  double delta = 150,
}) async {
  await tester.scrollUntilVisible(
    finder,
    delta,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await scrollTo(tester, finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> chooseMenu(WidgetTester tester, String item) async {
  await tester.tap(find.byTooltip('Demo states').first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(item));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('ecranul principal: Loading, Error, Retry, Reload', (
    tester,
  ) async {
    await pumpNarrow(tester, SlowLearningRepository());
    expect(find.text('Hi, Kristin'), findsOneWidget);

    await chooseMenu(tester, 'Simulate error');
    await tester.pumpAndSettle();
    expect(find.text('Could not load the data'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Hi, Kristin'), findsOneWidget);

    await chooseMenu(tester, 'Reload data');
    expect(find.text('Loading your learning data...'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Learned today'), findsOneWidget);
    await scrollTo(tester, find.text('Meetup'));
    expect(find.text('Learning Plan'), findsOneWidget);
  });

  testWidgets('pagina cursului: căutare, filtre, sortare, favorite', (
    tester,
  ) async {
    await pumpNarrow(tester, FakeLearningRepository());
    await tapVisible(tester, find.text('My courses'));
    expect(find.text('React Front To back'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'kotlin');
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Reset filters'));
    await scrollTo(tester, find.text('Introduction to React'));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);

    Finder chip(String label) => find.widgetWithText(ChoiceChip, label);

    await tapVisible(tester, chip('Locked'));
    await scrollTo(tester, find.text('Build React'));
    expect(find.text('Introduction to React'), findsNothing);

    await tapVisible(tester, chip('Completed'));
    await scrollTo(tester, find.text('No lessons found'));

    await tapVisible(tester, chip('Available'));
    await scrollTo(tester, find.text('Create first React project'));
    expect(find.text('Build React'), findsNothing);

    await tapVisible(tester, chip('All'));
    await tester.tap(find.byTooltip('Sort lessons'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<LessonSort>, 'Title A-Z'),
    );
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Build React'));
    final first = tester.getTopLeft(find.text('Build React'));
    final second = tester.getTopLeft(find.text('Create first React project'));
    expect(first.dy, lessThan(second.dy));

    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Build React'), findsOneWidget);
    expect(find.text('Create first React project'), findsNothing);

    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No favorites yet'), findsOneWidget);
  });

  testWidgets('detalii lecție, Next, Enroll și Description', (tester) async {
    await pumpNarrow(tester, FakeLearningRepository());
    await tapVisible(tester, find.text('Get Started'));

    await tapVisible(tester, find.text('Understanding React'));
    expect(find.text('Part of React Front To back'), findsOneWidget);
    await tapVisible(tester, find.text('Mark as completed'));
    expect(find.text('Mark as not completed'), findsOneWidget);

    await tapVisible(tester, find.textContaining('Next: '));
    expect(find.text('Create first React project'), findsOneWidget);
    await tapVisible(tester, find.textContaining('Next: '));
    expect(find.text('Build React'), findsOneWidget);
    expect(find.text('Locked'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('1 of 4 lessons completed'), delta: -150);

    await tester.tap(find.text('Enroll Now'));
    await tester.pumpAndSettle();
    expect(find.text('Enrolled'), findsOneWidget);
    await tapVisible(tester, find.text('Build React'));
    expect(find.text('Mark as completed'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Description'));
    await scrollTo(tester, find.text('No description yet'));
  });

  testWidgets('pagina cursului: Simulate error și Retry', (tester) async {
    await pumpNarrow(tester, FakeLearningRepository());
    await tapVisible(tester, find.text('My courses'));

    await chooseMenu(tester, 'Simulate error');
    await tester.pumpAndSettle();
    expect(find.text('Could not load the data'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    await scrollTo(tester, find.text('Introduction to React'));
  });
}
