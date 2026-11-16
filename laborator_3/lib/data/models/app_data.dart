import 'course_overview.dart';
import 'home_page_data.dart';
import 'json_utils.dart';

/// Rădăcina fișierului `assets/data/lab_v4.json`.
class AppData {
  const AppData({required this.home, required this.courseOverview});

  factory AppData.fromJson(Map<String, dynamic> json) => AppData(
    home: HomePageData.fromJson(readMap(json, 'homePage')),
    courseOverview: CourseOverview.fromJson(
      readMap(json, 'courseOverviewPage'),
    ),
  );

  final HomePageData home;
  final CourseOverview courseOverview;
}
