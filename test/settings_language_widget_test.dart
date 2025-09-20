import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:film_sms/main.dart';
import 'package:film_sms/data/datasources/hive_storage.dart';
import 'package:film_sms/data/models/contact.dart';
import 'package:film_sms/data/models/conversation.dart';
import 'package:film_sms/data/repositories/app_settings_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeStorage extends HiveStorage {
  List<Contact> contacts;
  List<Conversation> conversations;
  _FakeStorage(this.contacts, this.conversations);

  @override
  Future<List<Contact>> getContacts() async => contacts;

  @override
  Future<void> saveContacts(List<Contact> contacts) async {
    this.contacts = contacts;
  }

  @override
  Future<List<Conversation>> getConversations() async => conversations;

  @override
  Future<void> saveConversations(List<Conversation> conversations) async {
    this.conversations = conversations;
  }
}

class _FakeSettingsRepo extends AppSettingsRepository {
  String? _code;
  _FakeSettingsRepo() : super(HiveStorage());

  @override
  Future<Locale?> getLocaleOverride() async {
    return _code == null ? null : Locale(_code!);
  }

  @override
  Future<void> setLocaleOverride(Locale? locale) async {
    _code = locale?.languageCode;
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nl_BE', null);
    await initializeDateFormatting('nl', null);
  });

  testWidgets('Settings: switching language updates app title', (tester) async {
    final contact = Contact(
      name: 'De Lijn',
      phoneNumber: '+32488414',
      type: ContactType.transport,
    );
    final storage = _FakeStorage(
      [contact],
      [Conversation(contactId: contact.id)],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hiveStorageProvider.overrideWithValue(storage),
          appSettingsRepositoryProvider.overrideWithValue(_FakeSettingsRepo()),
        ],
        child: const FilmSMSApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Default title should be localized (either NL or EN). Open menu and go to settings.
    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    final settingsItem = find.text('Settings').evaluate().isNotEmpty
        ? find.text('Settings')
        : find.text('Instellingen');
    expect(settingsItem, findsOneWidget);
    await tester.tap(settingsItem);
    await tester.pumpAndSettle();

    // Tap language tile to open dialog
    await tester.tap(
      find.text('Language').hitTestable().evaluate().isNotEmpty
          ? find.text('Language')
          : find.text('Taal'),
    );
    await tester.pumpAndSettle();

    // Select English
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Pop back to list
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Title should be English now
    expect(find.text('Messages'), findsOneWidget);
  });
}
