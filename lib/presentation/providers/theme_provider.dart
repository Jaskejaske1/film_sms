import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider.autoDispose<ThemeModeSetting>(
  (ref) => ThemeModeSetting.system,
);

enum ThemeModeSetting { light, dark, system }
