import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';

/// Stările ecranului principal. Clasa este `sealed`, deci `switch` din UI
/// trebuie să trateze toate cele patru variante.
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Datele se încarcă din fișierul JSON.
final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Datele s-au încărcat și planul de învățare are elemente.
final class HomeSuccess extends HomeState {
  const HomeSuccess(this.data);

  final HomePageData data;

  @override
  List<Object?> get props => [data];
}

/// Datele s-au încărcat, dar planul de învățare este gol.
final class HomeEmpty extends HomeState {
  const HomeEmpty(this.data);

  final HomePageData data;

  @override
  List<Object?> get props => [data];
}

/// Citirea sau parsarea datelor a eșuat.
final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
