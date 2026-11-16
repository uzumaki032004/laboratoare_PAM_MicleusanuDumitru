import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app_lab3/data/repositories/learning_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('încarcă asincron fișierul JSON din assets', () async {
    final repository = AssetLearningRepository(delay: Duration.zero);

    final data = await repository.loadData();

    expect(data.home.header.greeting, 'Hi, Kristin');
    expect(data.courseOverview.course.lessons, hasLength(4));
  });

  test('a doua încărcare folosește aceleași date din cache', () async {
    final repository = AssetLearningRepository(delay: Duration.zero);

    final first = await repository.loadData();
    final second = await repository.loadData();
    final refreshed = await repository.loadData(forceRefresh: true);

    expect(identical(first, second), isTrue);
    expect(identical(first, refreshed), isFalse);
  });

  test('simularea erorii aruncă o excepție', () async {
    final repository = AssetLearningRepository(delay: Duration.zero);

    await expectLater(
      repository.loadData(simulateError: true),
      throwsA(anything),
    );
  });
}
