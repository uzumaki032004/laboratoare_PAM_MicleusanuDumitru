import 'package:flutter_bloc/flutter_bloc.dart';

/// Starea este mulțimea id-urilor lecțiilor favorite.
/// Favoritele se păstrează în memorie pe durata sesiunii.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit() : super(const <String>{});

  bool isFavorite(String lessonId) => state.contains(lessonId);

  void toggle(String lessonId) {
    final next = Set<String>.of(state);
    if (!next.remove(lessonId)) next.add(lessonId);
    emit(Set.unmodifiable(next));
  }
}
