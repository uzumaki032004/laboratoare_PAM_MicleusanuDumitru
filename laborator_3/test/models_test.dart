import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app_lab3/data/models/models.dart';

void main() {
  late AppData data;

  setUpAll(() {
    final raw = File('assets/data/lab_v4.json').readAsStringSync();
    data = AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('parsează ecranul principal din JSON', () {
    expect(data.home.header.greeting, 'Hi, Kristin');
    expect(data.home.header.hasUnreadNotifications, isTrue);
    expect(data.home.learnedToday.learnedMinutes, 46);
    expect(data.home.learnedToday.goalMinutes, 60);
    expect(data.home.learningPlan.items, hasLength(2));
    expect(data.home.learningPlan.items.first.title, 'Packaging Design');
  });

  test('parsează cursul și lecțiile', () {
    final course = data.courseOverview.course;
    expect(course.title, 'React Front To back');
    expect(course.rating, 4.9);
    expect(course.lessons, hasLength(4));
    expect(course.lessons[3].locked, isTrue);
    expect(course.selectedTabId, 'lessons');
    expect(course.description, isEmpty);
    expect(data.courseOverview.price.label, 'Free');
  });

  test('un câmp lipsă produce FormatException', () {
    expect(
      () => Lesson.fromJson(const {'id': 'x'}),
      throwsA(isA<FormatException>()),
    );
  });
}
