import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/learning_repository.dart';
import '../error_message.dart';
import 'home_state.dart';

/// Gestionează starea ecranului principal.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeLoading());

  final LearningRepository _repository;

  /// Încărcare cu ecran de Loading (prima pornire, „Reload”, „Retry”).
  Future<void> load({bool refresh = false, bool simulateError = false}) async {
    emit(const HomeLoading());
    await _fetch(refresh: refresh, simulateError: simulateError);
  }

  /// Folosit de pull-to-refresh: conținutul rămâne vizibil în timpul citirii.
  Future<void> refresh() => _fetch(refresh: true);

  Future<void> _fetch({
    required bool refresh,
    bool simulateError = false,
  }) async {
    try {
      final data = await _repository.loadData(
        forceRefresh: refresh,
        simulateError: simulateError,
      );
      if (isClosed) return;
      emit(_stateFor(data.home));
    } catch (error) {
      if (isClosed) return;
      emit(HomeError(describeError(error)));
    }
  }

  HomeState _stateFor(HomePageData home) =>
      home.learningPlan.items.isEmpty ? HomeEmpty(home) : HomeSuccess(home);
}
