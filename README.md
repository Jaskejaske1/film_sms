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

## Web

Build commands:

```powershell
# Local (with source maps for debugging)
flutter build web --release --source-maps --base-href=/film-sms/ --no-wasm-dry-run

# CI (lean, no source maps)
flutter build web --release --base-href=/film-sms/ --no-wasm-dry-run
```

Deploy notes:

- Upload the contents of `build/web` to your `/film-sms/` subfolder.
- Include `web/.htaccess` (copied into `build/web` by CI) for SPA routing and MIME types.
- If switching hosts or folders, ensure `RewriteBase` in `web/.htaccess` matches your path.
- Clear any stale files on the server before uploading to avoid old assets lingering.

Apache `.htaccess` expectations:

- MIME types: `.js`, `.css`, `.json`, and `.wasm`.
- Security: `X-Content-Type-Options: nosniff`.
- SPA: rewrite everything to `index.html`, except existing files/dirs.

### PWA (installable)

- Icons are in `web/icons/` (192/512 and maskable variants). Replace with your finalized branding.
- Manifest `web/manifest.json` sets name, short_name, theme/background colors.
- `web/index.html` includes `<meta name="theme-color">` and Apple touch icon.
- To refresh install banners and icons, hard-refresh or bump `version.json` by rebuilding.

## Contributing

- Keep changes minimal and focused
- Add tests for non-trivial logic
- Follow ARB localization workflow and avoid editing generated files
