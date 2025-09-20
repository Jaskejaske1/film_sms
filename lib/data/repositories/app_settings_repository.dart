import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/hive_storage.dart';
import 'package:flutter/material.dart';

class AppSettingsRepository {
  final HiveStorage _storage;
  AppSettingsRepository(this._storage);

  Future<Locale?> getLocaleOverride() async {
    final code = await _storage.getLanguageOverride();
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> setLocaleOverride(Locale? locale) async {
    await _storage.setLanguageOverride(locale?.languageCode);
  }
}

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return AppSettingsRepository(storage);
});
