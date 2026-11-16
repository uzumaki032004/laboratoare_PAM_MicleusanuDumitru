import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_theme.dart';
import 'data/repositories/learning_repository.dart';
import 'logic/favorites/favorites_cubit.dart';
import 'logic/home/home_cubit.dart';
import 'logic/lessons/lessons_cubit.dart';
import 'presentation/screens/home_screen.dart';

/// Rădăcina aplicației: repository-ul și Cubit-urile sunt oferite
/// tuturor ecranelor prin `RepositoryProvider` și `MultiBlocProvider`.
class LearningApp extends StatelessWidget {
  const LearningApp({super.key, required this.repository});

  final LearningRepository repository;

  @override
  Widget build(BuildContext context) =>
      RepositoryProvider<LearningRepository>.value(
        value: repository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => HomeCubit(repository)..load()),
            BlocProvider(create: (_) => LessonsCubit(repository)..load()),
            BlocProvider(create: (_) => FavoritesCubit()),
          ],
          child: MaterialApp(
            title: 'Learning App - Lab 3',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            home: const HomeScreen(),
          ),
        ),
      );
}
