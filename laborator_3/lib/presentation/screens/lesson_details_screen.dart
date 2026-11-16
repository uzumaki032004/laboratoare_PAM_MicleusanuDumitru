import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../core/json_icon.dart';
import '../../data/models/models.dart';
import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/lessons/lessons_cubit.dart';
import '../../logic/lessons/lessons_state.dart';
import '../navigation.dart';
import '../widgets/common/app_network_image.dart';
import '../widgets/common/info_chip.dart';
import '../widgets/common/state_views.dart';

/// Pagina de detalii a unei lecții. Primește doar id-ul, iar datele
/// actuale (finalizat / blocat / favorit) le citește din Cubit-uri.
class LessonDetailsScreen extends StatelessWidget {
  const LessonDetailsScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) => BlocBuilder<LessonsCubit, LessonsState>(
    builder: (context, state) {
      final lesson = state.lessonById(lessonId);
      final overview = state.overview;
      if (lesson == null || overview == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const EmptyView(
            icon: Icons.help_outline_rounded,
            title: 'Lesson not found',
            message: 'Go back and choose another lesson.',
          ),
        );
      }
      final isFavorite = context.watch<FavoritesCubit>().state.contains(
        lessonId,
      );
      final index = state.indexOf(lessonId);
      final next = index + 1 < state.lessons.length
          ? state.lessons[index + 1]
          : null;

      return Scaffold(
        appBar: AppBar(
          title: Text('Lesson ${lessonNumber(index)}'),
          actions: [
            IconButton(
              tooltip: isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
              onPressed: () => context.read<FavoritesCubit>().toggle(lessonId),
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? AppColors.primary : null,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _LessonPreview(
              lesson: lesson,
              imageUrl: overview.course.hero.imageUrl,
            ),
            const SizedBox(height: 18),
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Part of ${overview.course.title}',
              style: const TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                InfoChip(
                  icon: Icons.schedule_rounded,
                  label:
                      '${lesson.duration} '
                      '(${formatSeconds(lesson.durationSeconds)})',
                ),
                InfoChip(
                  icon: Icons.format_list_numbered_rounded,
                  label: 'Lesson ${index + 1} of ${state.lessons.length}',
                ),
                _statusChip(lesson),
              ],
            ),
            const SizedBox(height: 24),
            if (lesson.locked) ...[
              const Text(
                'This lesson is locked. Enroll in the course to unlock it.',
                style: TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: overview.enroll.enabled
                    ? () => context.read<LessonsCubit>().enroll()
                    : null,
                icon: const Icon(Icons.lock_open_rounded),
                label: Text(overview.enroll.label),
              ),
            ] else
              FilledButton.icon(
                onPressed: () =>
                    context.read<LessonsCubit>().toggleCompleted(lessonId),
                icon: Icon(
                  lesson.completed ? Icons.undo_rounded : Icons.check_rounded,
                ),
                label: Text(
                  lesson.completed
                      ? 'Mark as not completed'
                      : 'Mark as completed',
                ),
              ),
            if (next != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 50),
                  foregroundColor: AppColors.primary,
                ),
                onPressed: () => AppNavigator.replaceLesson(context, next.id),
                child: Text(
                  'Next: ${next.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      );
    },
  );

  Widget _statusChip(Lesson lesson) {
    if (lesson.locked) {
      return const InfoChip(
        icon: Icons.lock_rounded,
        label: 'Locked',
        color: AppColors.grey,
      );
    }
    if (lesson.completed) {
      return const InfoChip(
        icon: Icons.check_circle_rounded,
        label: 'Completed',
        color: AppColors.success,
      );
    }
    return const InfoChip(
      icon: Icons.play_circle_outline_rounded,
      label: 'Available',
      color: AppColors.primary,
    );
  }
}

class _LessonPreview extends StatelessWidget {
  const _LessonPreview({required this.lesson, required this.imageUrl});

  final Lesson lesson;
  final String imageUrl;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 190,
    child: Stack(
      fit: StackFit.expand,
      children: [
        AppNetworkImage(imageUrl, borderRadius: BorderRadius.circular(20)),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0x55000000),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: lesson.locked
                ? const Icon(Icons.lock_rounded, color: AppColors.grey)
                : JsonIcon(
                    lesson.playIconUrl,
                    size: 40,
                    color: AppColors.primary,
                  ),
          ),
        ),
      ],
    ),
  );
}
