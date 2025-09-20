import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeOverrideProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n?.settingsTitle ?? 'Instellingen')),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n?.settingsLanguage ?? 'Taal'),
            subtitle: Text(_languageLabel(l10n, locale)),
            onTap: () async {
              final selected = await showDialog<String?>(
                context: context,
                builder: (ctx) =>
                    _LanguageDialog(current: locale?.languageCode),
              );
              if (selected == null) return;
              final newLocale = selected.isEmpty ? null : Locale(selected);
              await ref
                  .read(localeOverrideProvider.notifier)
                  .setLocale(newLocale);
            },
          ),
        ],
      ),
    );
  }

  String _languageLabel(AppLocalizations? l10n, Locale? locale) {
    if (locale == null)
      return l10n?.languageSystemDefault ?? 'Systeemstandaard';
    switch (locale.languageCode) {
      case 'en':
        return l10n?.languageEnglish ?? 'Engels';
      case 'nl':
        return l10n?.languageDutch ?? 'Nederlands';
      default:
        return locale.toLanguageTag();
    }
  }
}

class _LanguageDialog extends StatelessWidget {
  final String? current;
  const _LanguageDialog({required this.current});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n?.settingsLanguage ?? 'Taal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            value: '',
            groupValue: current ?? '',
            onChanged: (v) => Navigator.of(context).pop(v),
            title: Text(l10n?.languageSystemDefault ?? 'Systeemstandaard'),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: current ?? '',
            onChanged: (v) => Navigator.of(context).pop(v),
            title: Text(l10n?.languageEnglish ?? 'Engels'),
          ),
          RadioListTile<String>(
            value: 'nl',
            groupValue: current ?? '',
            onChanged: (v) => Navigator.of(context).pop(v),
            title: Text(l10n?.languageDutch ?? 'Nederlands'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n?.cancel ?? 'Annuleren'),
        ),
      ],
    );
  }
}
