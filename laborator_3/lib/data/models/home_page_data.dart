import 'json_utils.dart';

/// Datele ecranului principal (`homePage` din JSON).
class HomePageData {
  const HomePageData({
    required this.header,
    required this.learnedToday,
    required this.myCourses,
    required this.learningPrompt,
    required this.learningPlan,
    required this.meetup,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) => HomePageData(
    header: HomeHeader.fromJson(readMap(json, 'header')),
    learnedToday: LearnedToday.fromJson(readMap(json, 'learnedToday')),
    myCourses: SectionAction.fromJson(readMap(json, 'myCourses')),
    learningPrompt: LearningPrompt.fromJson(readMap(json, 'learningPrompt')),
    learningPlan: LearningPlan.fromJson(readMap(json, 'learningPlan')),
    meetup: Meetup.fromJson(readMap(json, 'meetup')),
  );

  final HomeHeader header;
  final LearnedToday learnedToday;
  final SectionAction myCourses;
  final LearningPrompt learningPrompt;
  final LearningPlan learningPlan;
  final Meetup meetup;
}

class HomeHeader {
  const HomeHeader({
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
    required this.hasUnreadNotifications,
    required this.notificationIconUrl,
  });

  factory HomeHeader.fromJson(Map<String, dynamic> json) {
    final notification = readMap(json, 'notification');
    return HomeHeader(
      greeting: readValue<String>(json, 'greeting'),
      subtitle: readValue<String>(json, 'subtitle'),
      avatarUrl: readValue<String>(json, 'avatarUrl'),
      hasUnreadNotifications: readValue<bool>(notification, 'hasUnread'),
      notificationIconUrl: readValue<String>(notification, 'iconUrl'),
    );
  }

  final String greeting;
  final String subtitle;
  final String avatarUrl;
  final bool hasUnreadNotifications;
  final String notificationIconUrl;
}

class LearnedToday {
  const LearnedToday({
    required this.title,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.formatted,
    required this.progress,
  });

  factory LearnedToday.fromJson(Map<String, dynamic> json) => LearnedToday(
    title: readValue<String>(json, 'title'),
    learnedMinutes: readValue<int>(json, 'learnedMinutes'),
    goalMinutes: readValue<int>(json, 'goalMinutes'),
    formatted: readValue<String>(json, 'formatted'),
    progress: readDouble(json, 'progress'),
  );

  final String title;
  final int learnedMinutes;
  final int goalMinutes;
  final String formatted;
  final double progress;
}

/// Secțiune simplă cu titlu și text pentru buton (de ex. „My courses”).
class SectionAction {
  const SectionAction({required this.title, required this.actionLabel});

  factory SectionAction.fromJson(Map<String, dynamic> json) => SectionAction(
    title: readValue<String>(json, 'title'),
    actionLabel: readValue<String>(json, 'actionLabel'),
  );

  final String title;
  final String actionLabel;
}

class LearningPrompt {
  const LearningPrompt({
    required this.title,
    required this.actionLabel,
    required this.imageUrl,
  });

  factory LearningPrompt.fromJson(Map<String, dynamic> json) => LearningPrompt(
    title: readValue<String>(json, 'title'),
    actionLabel: readValue<String>(json, 'actionLabel'),
    imageUrl: readValue<String>(json, 'imageUrl'),
  );

  final String title;
  final String actionLabel;
  final String imageUrl;
}

class LearningPlan {
  const LearningPlan({required this.title, required this.items});

  factory LearningPlan.fromJson(Map<String, dynamic> json) => LearningPlan(
    title: readValue<String>(json, 'title'),
    items: [
      for (final item in readMapList(json, 'items'))
        LearningPlanItem.fromJson(item),
    ],
  );

  final String title;
  final List<LearningPlanItem> items;
}

class LearningPlanItem {
  const LearningPlanItem({
    required this.id,
    required this.title,
    required this.completed,
    required this.total,
    required this.progress,
    required this.progressIconUrl,
  });

  factory LearningPlanItem.fromJson(Map<String, dynamic> json) =>
      LearningPlanItem(
        id: readValue<String>(json, 'id'),
        title: readValue<String>(json, 'title'),
        completed: readValue<int>(json, 'completed'),
        total: readValue<int>(json, 'total'),
        progress: readDouble(json, 'progress'),
        progressIconUrl: readValue<String>(json, 'progressIconUrl'),
      );

  final String id;
  final String title;
  final int completed;
  final int total;
  final double progress;
  final String progressIconUrl;
}

class Meetup {
  const Meetup({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  factory Meetup.fromJson(Map<String, dynamic> json) => Meetup(
    title: readValue<String>(json, 'title'),
    subtitle: readValue<String>(json, 'subtitle'),
    imageUrl: readValue<String>(json, 'imageUrl'),
  );

  final String title;
  final String subtitle;
  final String imageUrl;
}
