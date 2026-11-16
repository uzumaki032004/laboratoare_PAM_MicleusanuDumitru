import 'dart:convert';
import 'dart:io';

import 'package:learning_app_lab3/data/models/models.dart';
import 'package:learning_app_lab3/data/repositories/learning_repository.dart';

/// Citește fișierul real din assets pentru teste.
AppData loadTestData() {
  final raw = File('assets/data/lab_v4.json').readAsStringSync();
  return AppData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

/// Repository fals: întoarce imediat datele, fără întârziere.
class FakeLearningRepository implements LearningRepository {
  FakeLearningRepository([AppData? data]) : data = data ?? loadTestData();

  final AppData data;
  int calls = 0;

  @override
  Future<AppData> loadData({
    bool forceRefresh = false,
    bool simulateError = false,
  }) async {
    calls++;
    if (simulateError) throw const FormatException('simulated');
    return data;
  }
}

/// Repository care eșuează mereu, pentru starea Error.
class FailingLearningRepository implements LearningRepository {
  @override
  Future<AppData> loadData({
    bool forceRefresh = false,
    bool simulateError = false,
  }) async => throw const FormatException('broken file');
}
