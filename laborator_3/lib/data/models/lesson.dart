import 'package:equatable/equatable.dart';

import 'json_utils.dart';

/// O lecție din lista cursului (`courseOverviewPage.course.lessons`).
class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationSeconds,
    required this.completed,
    required this.locked,
    required this.playIconUrl,
    required this.arrowIconUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: readValue<String>(json, 'id'),
    title: readValue<String>(json, 'title'),
    duration: readValue<String>(json, 'duration'),
    durationSeconds: readValue<int>(json, 'durationSeconds'),
    completed: readValue<bool>(json, 'completed'),
    locked: readValue<bool>(json, 'locked'),
    playIconUrl: readValue<String>(json, 'playIconUrl'),
    arrowIconUrl: readValue<String>(json, 'arrowIconUrl'),
  );

  final String id;
  final String title;

  /// Durata afișată, de exemplu `04:28`.
  final String duration;
  final int durationSeconds;
  final bool completed;
  final bool locked;
  final String playIconUrl;
  final String arrowIconUrl;

  Lesson copyWith({bool? completed, bool? locked}) => Lesson(
    id: id,
    title: title,
    duration: duration,
    durationSeconds: durationSeconds,
    completed: completed ?? this.completed,
    locked: locked ?? this.locked,
    playIconUrl: playIconUrl,
    arrowIconUrl: arrowIconUrl,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    duration,
    durationSeconds,
    completed,
    locked,
    playIconUrl,
    arrowIconUrl,
  ];
}
