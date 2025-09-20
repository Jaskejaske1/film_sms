import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/app_settings_repository.dart';

final localeOverrideProvider =
    StateNotifierProvider<LocaleOverrideController, Locale?>(
      (ref) =>
          LocaleOverrideController(ref.read(appSettingsRepositoryProvider)),
    );

class LocaleOverrideController extends StateNotifier<Locale?> {
  final AppSettingsRepository _repo;
  LocaleOverrideController(this._repo) : super(null) {
    _load();
  }

  Future<void> _load() async {
    state = await _repo.getLocaleOverride();
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    await _repo.setLocaleOverride(locale);
  }
}
