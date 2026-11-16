import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/formatters.dart';
import '../../../core/json_icon.dart';
import '../../../data/models/models.dart';

/// Un element al listei de lecții. Este refolosit în pagina cursului
/// și în pagina de favorite.
class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.index,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Lesson lesson;

  /// Poziția lecției în curs (nu în lista filtrată).
  final int index;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
        child: Row(
          children: [
            SizedBox(
              width: 38,
              child: Text(
                lessonNumber(index),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.lessonNumber,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: lesson.locked ? AppColors.grey : AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${lesson.duration} mins',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),
                      if (lesson.completed)
                        const _Badge(
                          icon: Icons.check_circle_rounded,
                          label: 'Done',
                          color: AppColors.success,
                        ),
                      if (lesson.locked)
                        const _Badge(
                          icon: Icons.lock_rounded,
                          label: 'Locked',
                          color: AppColors.grey,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
              onPressed: onFavoriteToggle,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? AppColors.primary : AppColors.grey,
              ),
            ),
            JsonIcon(lesson.playIconUrl, size: 36),
          ],
        ),
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 2),
      Text(label, style: TextStyle(fontSize: 12, color: color)),
    ],
  );
}
