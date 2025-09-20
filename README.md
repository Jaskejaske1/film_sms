# Film SMS

Professional fake SMS app for film production.

## Overview

- **Tech**: Flutter, Riverpod, Hive, intl
- **Platforms**: Android, iOS, Web, macOS, Windows, Linux
- **Core features**:
  - Conversations + contacts with persistent storage (Hive)
  - Template engine (incl. De Lijn SMS) with variables and formatting
  - In‑app language selection (System / English / Dutch)
  - ARB‑driven localization with `flutter gen-l10n`
  - Unit + widget tests for key flows

## Architecture

- `lib/core`: constants, template engine, formatters, themes
- `lib/data`: datasources (Hive) + repositories
- `lib/domain`: entities + usecases (GenerateDeLijnSMS, etc.)
- `lib/presentation`: pages, providers (Riverpod), widgets
- `lib/l10n`: ARB files and generated localizations (do not edit generated Dart)

State is managed via Riverpod. `FilmSMSApp` is a `ConsumerWidget` so `MaterialApp.locale` updates immediately when the language setting changes.

## Getting Started

```powershell
# Fetch packages
flutter pub get

# Generate Hive/other code if needed
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localizations from ARB
flutter gen-l10n

# Run the app
flutter run

# Run tests
flutter test
```

## Localization (ARB)

- Source of truth: `lib/l10n/app_en.arb`, `lib/l10n/app_nl.arb`
- Configuration: `l10n.yaml`
- Generated files: `lib/l10n/app_localizations.dart` and per‑locale files
- Usage in code:

```dart
final l10n = AppLocalizations.of(context);
Text(l10n?.menuSettings ?? 'Settings');
```

- Update flow:
  1. Edit ARB files (add keys for both languages)
  2. Run `flutter gen-l10n`
  3. Rebuild/run tests

Note: Do not manually edit the generated `app_localizations*.dart` files.

## Settings (Language Override)

- Stored in Hive via `AppSettingsRepository`
- Provider: `localeOverrideProvider`
- UI: `SettingsPage` (`/settings`) with System/English/Dutch options

## Template Engine

- Supports variable types: userInput, static, time/date calculators, code/price generators
- Includes Belgian formatter helpers (dates/times/prices)
- De Lijn use case ensures template presence and composes the SMS

## Testing

- Run: `flutter test`
- Coverage highlights:
  - Formatters + sorting tiebreakers
  - Template engine + De Lijn use case
  - Widget flows: settings language switch, template injection (menu + sheet)

## Contributing

- Keep changes minimal and focused
- Add tests for non-trivial logic
- Follow ARB localization workflow and avoid editing generated files
