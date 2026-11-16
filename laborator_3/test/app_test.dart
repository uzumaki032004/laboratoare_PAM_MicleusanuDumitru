import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app_lab3/app.dart';
import 'package:learning_app_lab3/data/repositories/learning_repository.dart';

import 'helpers/test_data.dart';

Future<void> pumpApp(WidgetTester tester, LearningRepository repository) async {
  // Dimensiunea unui telefon obișnuit (390 x 844).
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(LearningApp(repository: repository));
  await tester.pumpAndSettle();
}

Future<void> openCourse(WidgetTester tester) async {
  final getStarted = find.text('Get Started');
  await tester.ensureVisible(getStarted);
  await tester.pumpAndSettle();
  await tester.tap(getStarted);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ecranul principal afișează datele din JSON', (tester) async {
    await pumpApp(tester, FakeLearningRepository());

    expect(find.text('Hi, Kristin'), findsOneWidget);
    expect(find.text('Learned today'), findsOneWidget);
    expect(find.text('Learning Plan'), findsOneWidget);
    expect(find.text('Packaging Design'), findsOneWidget);
    expect(find.text('Meetup'), findsOneWidget);
  });

  testWidgets('starea Error are buton Retry', (tester) async {
    await pumpApp(tester, FailingLearningRepository());

    expect(find.text('Could not load the data'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('căutarea filtrează lecțiile și arată starea Empty', (
    tester,
  ) async {
    await pumpApp(tester, FakeLearningRepository());
    await openCourse(tester);

    expect(find.text('React Front To back'), findsOneWidget);
    expect(find.text('Introduction to React'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'build');
    await tester.pumpAndSettle();
    expect(find.text('Build React'), findsOneWidget);
    expect(find.text('Introduction to React'), findsNothing);

    await tester.enterText(find.byType(TextField), 'kotlin');
    await tester.pumpAndSettle();
    expect(find.text('No lessons found'), findsOneWidget);
  });

  testWidgets('favorite și pagina de detalii', (tester) async {
    await pumpApp(tester, FakeLearningRepository());
    await openCourse(tester);

    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.tap(find.text('Introduction to React'));
    await tester.pumpAndSettle();
    expect(find.text('Part of React Front To back'), findsOneWidget);

    await tester.tap(find.text('Mark as completed'));
    await tester.pumpAndSettle();
    expect(find.text('Mark as not completed'), findsOneWidget);
  });
}
