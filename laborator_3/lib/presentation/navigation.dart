import 'package:flutter/material.dart';

import 'screens/course_overview_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/lesson_details_screen.dart';

/// Navigarea între ecrane, într-un singur loc.
abstract final class AppNavigator {
  static Future<void> openCourse(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const CourseOverviewScreen()));

  static Future<void> openFavorites(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()));

  static Future<void> openLesson(BuildContext context, String lessonId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => LessonDetailsScreen(lessonId: lessonId),
        ),
      );

  /// Trece la altă lecție fără a adăuga încă un ecran în stivă.
  static Future<void> replaceLesson(BuildContext context, String lessonId) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => LessonDetailsScreen(lessonId: lessonId),
        ),
      );

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
