import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/hive_storage.dart';
import 'presentation/pages/conversation_list_page.dart';
import 'core/themes/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  final hiveStorage = HiveStorage();
  await hiveStorage.init();

  runApp(
    ProviderScope(
      overrides: [hiveStorageProvider.overrideWithValue(hiveStorage)],
      child: const FilmSMSApp(),
    ),
  );
}

class FilmSMSApp extends ConsumerWidget {
  const FilmSMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeOverride = ref.watch(localeOverrideProvider);
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Berichten',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: localeOverride,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const ConversationListPage(),
      debugShowCheckedModeBanner: false,
      routes: {SettingsPage.routeName: (_) => const SettingsPage()},
    );
  }
}
