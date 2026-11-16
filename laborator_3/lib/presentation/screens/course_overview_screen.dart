import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../core/formatters.dart';
import '../../core/json_icon.dart';
import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/lessons/lesson_query.dart';
import '../../logic/lessons/lessons_cubit.dart';
import '../../logic/lessons/lessons_state.dart';
import '../navigation.dart';
import '../widgets/common/demo_states_menu.dart';
import '../widgets/common/state_views.dart';
import '../widgets/course/course_hero.dart';
import '../widgets/course/course_info_header.dart';
import '../widgets/course/course_tabs.dart';
import '../widgets/course/enroll_bar.dart';
import '../widgets/course/lesson_filter_bar.dart';
import '../widgets/course/lesson_search_bar.dart';
import '../widgets/course/lesson_tile.dart';

/// Pagina „Course Overview”: lista de lecții cu căutare, filtrare,
/// sortare și favorite, plus tab-ul „Description”.
class CourseOverviewScreen extends StatelessWidget {
  const CourseOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          final cubit = context.read<LessonsCubit>();
          final overview = state.overview;
          final showContent =
              state.status == LoadStatus.success ||
              state.status == LoadStatus.empty;
          return Scaffold(
            appBar: AppBar(
              leading: overview == null
                  ? null
                  : IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: JsonIcon(overview.backIconUrl, size: 26),
                    ),
              title: Text(overview?.navigationTitle ?? 'Course Overview'),
              actions: [
                IconButton(
                  tooltip: 'Favorites',
                  onPressed: () => AppNavigator.openFavorites(context),
                  icon: const Icon(Icons.favorite_border_rounded),
                ),
                DemoStatesMenu(
                  onReload: () => cubit.load(refresh: true),
                  onSimulateError: () => cubit.load(simulateError: true),
                ),
              ],
            ),
            body: switch (state.status) {
              LoadStatus.loading => const LoadingView(
                message: 'Loading course...',
              ),
              LoadStatus.error => ErrorView(
                message: state.errorMessage ?? 'Unknown error.',
                onRetry: cubit.load,
              ),
              LoadStatus.success || LoadStatus.empty => _CourseContent(
                state: state,
              ),
            },
            bottomNavigationBar: overview == null || !showContent
                ? null
                : EnrollBar(
                    price: overview.price,
                    enroll: overview.enroll,
                    enrolled: state.enrolled,
                    onEnroll: () {
                      cubit.enroll();
                      AppNavigator.showMessage(
                        context,
                        'You are enrolled. All lessons are unlocked.',
                      );
                    },
                  ),
          );
        },
      );
}

class _CourseContent extends StatelessWidget {
  const _CourseContent({required this.state});

  final LessonsState state;

  static const _lessonsTabId = 'lessons';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LessonsCubit>();
    final favorites = context.watch<FavoritesCubit>().state;
    final overview = state.overview!;
    final course = overview.course;
    final showLessons = state.selectedTabId == _lessonsTabId;
    final visible = state.visibleLessons;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          sliver: SliverList.list(
            children: [
              CourseHero(
                hero: course.hero,
                onPlay: () => _openFirstAvailable(context),
              ),
              const SizedBox(height: 16),
              CourseInfoHeader(
                course: course,
                icons: overview.icons,
                completedCount: state.completedCount,
                totalLessons: state.lessons.length,
              ),
              const SizedBox(height: 16),
              CourseTabs(
                tabs: course.tabs,
                selectedId: state.selectedTabId,
                onSelected: cubit.selectTab,
              ),
              const SizedBox(height: 16),
              if (showLessons) ...[
                LessonSearchBar(query: state.query, onChanged: cubit.search),
                const SizedBox(height: 10),
                LessonFilterBar(
                  filter: state.filter,
                  sort: state.sort,
                  onFilterChanged: cubit.setFilter,
                  onSortChanged: cubit.setSort,
                ),
                const SizedBox(height: 4),
                Text(
                  'Showing ${visible.length} of ${state.lessons.length} '
                  'lessons · ${formatSeconds(state.visibleDurationSeconds)}',
                  style: const TextStyle(color: AppColors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        if (!showLessons)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _DescriptionSection(text: course.description),
          )
        else if (state.status == LoadStatus.empty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyView(
              icon: Icons.search_off_rounded,
              title: 'No lessons found',
              message: 'Try another search term or filter.',
              action: TextButton(
                onPressed: () {
                  cubit.search('');
                  cubit.setFilter(LessonFilter.all);
                },
                child: const Text('Reset filters'),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: visible.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final lesson = visible[index];
                return LessonTile(
                  lesson: lesson,
                  index: state.indexOf(lesson.id),
                  isFavorite: favorites.contains(lesson.id),
                  onTap: () => AppNavigator.openLesson(context, lesson.id),
                  onFavoriteToggle: () =>
                      context.read<FavoritesCubit>().toggle(lesson.id),
                );
              },
            ),
          ),
      ],
    );
  }

  /// Butonul Play din imaginea cursului deschide prima lecție disponibilă.
  void _openFirstAvailable(BuildContext context) {
    for (final lesson in state.lessons) {
      if (!lesson.locked) {
        AppNavigator.openLesson(context, lesson.id);
        return;
      }
    }
    AppNavigator.showMessage(context, 'Enroll to unlock the lessons.');
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const EmptyView(
        icon: Icons.description_outlined,
        title: 'No description yet',
        message: 'The course description in the JSON file is empty.',
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Text(text, style: const TextStyle(height: 1.5)),
    );
  }
}
