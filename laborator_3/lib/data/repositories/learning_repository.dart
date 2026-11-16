import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';

/// Sursa de date a aplicației. Cubit-urile depind doar de această interfață,
/// astfel încât în teste se poate folosi o implementare falsă.
abstract interface class LearningRepository {
  /// Încarcă asincron toate datele aplicației.
  ///
  /// [forceRefresh] ignoră datele din cache și citește din nou fișierul.
  /// [simulateError] citește intenționat un fișier inexistent, pentru a
  /// demonstra starea Error în timpul prezentării.
  Future<AppData> loadData({
    bool forceRefresh = false,
    bool simulateError = false,
  });
}

/// Citește `assets/data/lab_v4.json` din pachetul aplicației.
class AssetLearningRepository implements LearningRepository {
  AssetLearningRepository({
    AssetBundle? bundle,
    this.assetPath = defaultAssetPath,
    this.delay = const Duration(milliseconds: 900),
  }) : _bundle = bundle ?? rootBundle;

  static const defaultAssetPath = 'assets/data/lab_v4.json';
  static const _missingAssetPath = 'assets/data/fisier_inexistent.json';

  final AssetBundle _bundle;
  final String assetPath;

  /// Întârziere artificială, ca starea Loading să fie vizibilă la prezentare.
  final Duration delay;

  Future<AppData>? _cache;

  @override
  Future<AppData> loadData({
    bool forceRefresh = false,
    bool simulateError = false,
  }) {
    if (simulateError) return _read(_missingAssetPath);
    if (forceRefresh || _cache == null) {
      _cache = _read(assetPath);
    }
    return _cache!;
  }

  Future<AppData> _read(String path) async {
    try {
      if (delay > Duration.zero) await Future<void>.delayed(delay);
      // loadString este asincron: fișierul este citit fără a bloca interfața.
      final raw = await _bundle.loadString(path, cache: false);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Rădăcina JSON trebuie să fie un obiect.');
      }
      return AppData.fromJson(decoded);
    } catch (_) {
      // O eroare nu rămâne în cache: următoarea încercare citește din nou.
      if (path == assetPath) _cache = null;
      rethrow;
    }
  }
}
