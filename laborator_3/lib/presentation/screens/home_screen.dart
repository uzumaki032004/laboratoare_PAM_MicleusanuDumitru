import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_colors.dart';
import '../../data/models/models.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import '../navigation.dart';
import '../widgets/common/demo_states_menu.dart';
import '../widgets/common/state_views.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/learned_today_card.dart';
import '../widgets/home/learning_plan_card.dart';
import '../widgets/home/promo_card.dart';

/// Ecranul principal. `BlocBuilder` reconstruiește UI-ul la fiecare stare.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => switch (state) {
        HomeLoading() => const LoadingView(
          message: 'Loading your learning data...',
        ),
        HomeError(:final message) => SafeArea(
          child: ErrorView(
            message: message,
            onRetry: () => context.read<HomeCubit>().load(),
          ),
        ),
        HomeSuccess(:final data) => _HomeContent(data: data),
        HomeEmpty(:final data) => _HomeContent(data: data),
      },
    ),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.data});

  final HomePageData data;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: cubit.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    HomeHeaderBar(
                      header: data.header,
                      onFavorites: () => AppNavigator.openFavorites(context),
                      onNotifications: () => AppNavigator.showMessage(
                        context,
                        data.header.hasUnreadNotifications
                            ? 'You have unread notifications'
                            : 'No new notifications',
                      ),
                      menu: DemoStatesMenu(
                        color: Colors.white,
                        onReload: () => cubit.load(refresh: true),
                        onSimulateError: () => cubit.load(simulateError: true),
                      ),
                    ),
                    const SizedBox(height: 84),
                  ],
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: LearnedTodayCard(
                    data: data.learnedToday,
                    actionLabel: data.myCourses.actionLabel,
                    onAction: () => AppNavigator.openCourse(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PromoCard(
                    title: data.learningPrompt.title,
                    imageUrl: data.learningPrompt.imageUrl,
                    backgroundColor: AppColors.primaryLight,
                    actionLabel: data.learningPrompt.actionLabel,
                    onAction: () => AppNavigator.openCourse(context),
                  ),
                  const SizedBox(height: 24),
                  LearningPlanCard(plan: data.learningPlan),
                  const SizedBox(height: 24),
                  PromoCard(
                    title: data.meetup.title,
                    subtitle: data.meetup.subtitle,
                    imageUrl: data.meetup.imageUrl,
                    backgroundColor: AppColors.meetup,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
