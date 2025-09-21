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
  - **Contact/phone/message linking:**
    - Each conversation is tied to a contact by unique ID.
    - Contacts are seeded with realistic Belgian names and types.
    - Messages are linked to conversations and contacts; unread counts are tracked and cleared on open.
  - **Phone number display rules:**
    - If a contact has a name, the conversation list shows the name as the title and the phone number (formatted) as a subtitle.
    - If a contact has no name, the list title shows the formatted phone number; subtitle is omitted to avoid duplication.
    - In the detail view, the AppBar title is the name (if present) or the formatted phone number. The subtitle (below the title) shows the phone number only when a name exists.
  - **Deterministic phone generation:**
    - On reseed, blank phone numbers are filled deterministically using the contact name as a seed, ensuring stable, realistic Belgian mobile numbers.
    - De Lijn always has a fixed number (`+32 488 414`), with no name.
  - **Testing:**
    - Widget tests cover list and detail phone display logic, De Lijn fallback, deterministic phone generation, and message linking.

## Architecture

- `lib/core`: constants, template engine, formatters, themes
- `lib/data`: datasources (Hive) + repositories
- `lib/domain`: entities + usecases (GenerateDeLijnSMS, etc.)
- `lib/presentation`: pages, providers (Riverpod), widgets
- `lib/l10n`: ARB files and generated localizations (do not edit generated Dart)

State is managed via Riverpod. `FilmSMSApp` is a `ConsumerWidget` so `MaterialApp.locale` updates immediately when the language setting changes.

## Developer Quickstart

```sh
# Analyze code
flutter analyze

# Run all tests
flutter test

# Build web (release, SPA)
flutter build web --release --source-maps --base-href=/film-sms/ --no-wasm-dry-run
```

## Data Model Overview

- `Contact`: id, name, phoneNumber, type, isDynamic
- `Conversation`: id, contactId, messages, lastMessageTime, unreadCount
- `Message`: body, timestamp, isIncoming, contactId

## Reseed Logic

- Use the menu to "Wipe data" or "Hard reset"; reseed will blank all phone numbers except De Lijn, then fill blanks deterministically.
- De Lijn always appears with no name and its fixed number.

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

## Android Signing & CI

- Signing is CI-only using GitHub Secrets; no signing files are committed.
- Required secrets: `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.
- One-time setup:
  - Generate keystore (PowerShell):
    - `& "$env:JAVA_HOME\bin\keytool.exe" -genkeypair -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
  - Base64 encode and add to secrets:
    - `[Convert]::ToBase64String([IO.File]::ReadAllBytes('upload-keystore.jks')) | Set-Content -NoNewline upload-keystore.jks.base64`
    - Copy file contents into `ANDROID_KEYSTORE_BASE64`.
- CI release job reconstructs the keystore and builds a signed `.aab` when a tag is pushed.

## Auto‑tagging

- On push to `main`/`master`, the workflow reads `version:` from `pubspec.yaml` and creates a `v<version>` tag if it doesn’t exist.
- Tag pushes (or the auto‑created tag) trigger the Android signed release job and publish the `.aab` as an artifact.

### PWA (installable)

- Icons are in `web/icons/` (192/512 and maskable variants). Replace with your finalized branding.
- Manifest `web/manifest.json` sets name, short_name, theme/background colors.
- `web/index.html` includes `<meta name="theme-color">` and Apple touch icon.
- To refresh install banners and icons, hard-refresh or bump `version.json` by rebuilding.

## Contributing

- Keep changes minimal and focused
- Add tests for non-trivial logic
- Follow ARB localization workflow and avoid editing generated files
