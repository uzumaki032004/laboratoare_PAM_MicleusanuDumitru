import 'json_utils.dart';
import 'lesson.dart';

/// Datele paginii „Course Overview” (`courseOverviewPage` din JSON).
class CourseOverview {
  const CourseOverview({
    required this.navigationTitle,
    required this.backIconUrl,
    required this.course,
    required this.price,
    required this.enroll,
    required this.icons,
  });

  factory CourseOverview.fromJson(Map<String, dynamic> json) {
    final navigation = readMap(json, 'navigation');
    final actions = readMap(json, 'actions');
    return CourseOverview(
      navigationTitle: readValue<String>(navigation, 'title'),
      backIconUrl: readValue<String>(navigation, 'backIconUrl'),
      course: Course.fromJson(readMap(json, 'course')),
      price: Price.fromJson(readMap(actions, 'price')),
      enroll: EnrollAction.fromJson(readMap(actions, 'enroll')),
      icons: CourseIcons.fromJson(readMap(json, 'uiIcons')),
    );
  }

  final String navigationTitle;
  final String backIconUrl;
  final Course course;
  final Price price;
  final EnrollAction enroll;
  final CourseIcons icons;
}

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationMinutes,
    required this.lessonCount,
    required this.rating,
    required this.hero,
    required this.tabs,
    required this.selectedTabId,
    required this.lessons,
    required this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final tabs = readMap(json, 'tabs');
    return Course(
      id: readValue<String>(json, 'id'),
      title: readValue<String>(json, 'title'),
      duration: readValue<String>(json, 'duration'),
      durationMinutes: readValue<int>(json, 'durationMinutes'),
      lessonCount: readValue<int>(json, 'lessonCount'),
      rating: readDouble(json, 'rating'),
      hero: CourseHeroData.fromJson(readMap(json, 'hero')),
      tabs: [
        for (final tab in readMapList(tabs, 'items')) CourseTab.fromJson(tab),
      ],
      selectedTabId: readValue<String>(tabs, 'selected'),
      lessons: [
        for (final lesson in readMapList(json, 'lessons'))
          Lesson.fromJson(lesson),
      ],
      description: readValue<String>(readMap(json, 'description'), 'text'),
    );
  }

  final String id;
  final String title;
  final String duration;
  final int durationMinutes;
  final int lessonCount;
  final double rating;
  final CourseHeroData hero;
  final List<CourseTab> tabs;
  final String selectedTabId;
  final List<Lesson> lessons;
  final String description;
}

class CourseHeroData {
  const CourseHeroData({
    required this.label,
    required this.imageUrl,
    required this.playIconUrl,
    required this.videoCount,
    required this.classCount,
  });

  factory CourseHeroData.fromJson(Map<String, dynamic> json) => CourseHeroData(
    label: readValue<String>(json, 'label'),
    imageUrl: readValue<String>(json, 'imageUrl'),
    playIconUrl: readValue<String>(json, 'playIconUrl'),
    videoCount: readValue<int>(json, 'videoCount'),
    classCount: readValue<int>(json, 'classCount'),
  );

  final String label;
  final String imageUrl;
  final String playIconUrl;
  final int videoCount;
  final int classCount;
}

class CourseTab {
  const CourseTab({required this.id, required this.label});

  factory CourseTab.fromJson(Map<String, dynamic> json) => CourseTab(
    id: readValue<String>(json, 'id'),
    label: readValue<String>(json, 'label'),
  );

  final String id;
  final String label;
}

class Price {
  const Price({
    required this.label,
    required this.amount,
    required this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    label: readValue<String>(json, 'label'),
    amount: readDouble(json, 'amount'),
    currency: readValue<String>(json, 'currency'),
  );

  final String label;
  final double amount;
  final String currency;
}

class EnrollAction {
  const EnrollAction({required this.label, required this.enabled});

  factory EnrollAction.fromJson(Map<String, dynamic> json) => EnrollAction(
    label: readValue<String>(json, 'label'),
    enabled: readValue<bool>(json, 'enabled'),
  );

  final String label;
  final bool enabled;
}

class CourseIcons {
  const CourseIcons({
    required this.durationIconUrl,
    required this.lessonsIconUrl,
    required this.ratingIconUrl,
  });

  factory CourseIcons.fromJson(Map<String, dynamic> json) => CourseIcons(
    durationIconUrl: readValue<String>(json, 'durationIconUrl'),
    lessonsIconUrl: readValue<String>(json, 'lessonsIconUrl'),
    ratingIconUrl: readValue<String>(json, 'ratingIconUrl'),
  );

  final String durationIconUrl;
  final String lessonsIconUrl;
  final String ratingIconUrl;
}
