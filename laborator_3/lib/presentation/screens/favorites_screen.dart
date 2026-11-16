import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/lessons/lessons_cubit.dart';
import '../../logic/lessons/lessons_state.dart';
import '../navigation.dart';
import '../widgets/common/state_views.dart';
import '../widgets/course/lesson_tile.dart';

/// Lista lecțiilor marcate cu inimă. Combină două Cubit-uri:
/// id-urile favorite (FavoritesCubit) și datele lecțiilor (LessonsCubit).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favorites')),
    body: BlocBuilder<FavoritesCubit, Set<String>>(
      builder: (context, favoriteIds) =>
          BlocBuilder<LessonsCubit, LessonsState>(
            builder: (context, state) {
              if (!state.hasData) {
                return state.status == LoadStatus.error
                    ? ErrorView(
                        message: state.errorMessage ?? 'Unknown error.',
                        onRetry: context.read<LessonsCubit>().load,
                      )
                    : const LoadingView();
              }
              final favorites = state.lessons
                  .where((lesson) => favoriteIds.contains(lesson.id))
                  .toList();
              if (favorites.isEmpty) {
                return const EmptyView(
                  icon: Icons.favorite_border_rounded,
                  title: 'No favorites yet',
                  message: 'Tap the heart next to a lesson to save it here.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: favorites.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final lesson = favorites[index];
                  return LessonTile(
                    lesson: lesson,
                    index: state.indexOf(lesson.id),
                    isFavorite: true,
                    onTap: () => AppNavigator.openLesson(context, lesson.id),
                    onFavoriteToggle: () =>
                        context.read<FavoritesCubit>().toggle(lesson.id),
                  );
                },
              );
            },
          ),
    ),
  );
}
