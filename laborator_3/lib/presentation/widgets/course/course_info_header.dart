import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/json_icon.dart';
import '../../../data/models/models.dart';

/// Titlul cursului și informațiile: durată, număr de lecții, rating.
class CourseInfoHeader extends StatelessWidget {
  const CourseInfoHeader({
    super.key,
    required this.course,
    required this.icons,
    required this.completedCount,
    required this.totalLessons,
  });

  final Course course;
  final CourseIcons icons;
  final int completedCount;
  final int totalLessons;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        course.title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.dark,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 16,
        runSpacing: 6,
        children: [
          CourseMetaItem(iconUrl: icons.durationIconUrl, text: course.duration),
          CourseMetaItem(
            iconUrl: icons.lessonsIconUrl,
            text: '${course.lessonCount} Lessons',
          ),
          CourseMetaItem(
            iconUrl: icons.ratingIconUrl,
            text: course.rating.toStringAsFixed(1),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        '$completedCount of $totalLessons lessons completed',
        style: const TextStyle(color: AppColors.grey, fontSize: 13),
      ),
    ],
  );
}

/// Pictogramă din JSON + text, folosită în rândul de informații.
class CourseMetaItem extends StatelessWidget {
  const CourseMetaItem({super.key, required this.iconUrl, required this.text});

  final String iconUrl;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      JsonIcon(iconUrl, size: 18),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(color: AppColors.grey)),
    ],
  );
}
