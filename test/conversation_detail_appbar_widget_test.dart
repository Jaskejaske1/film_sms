import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:film_sms/main.dart';
import 'package:film_sms/core/constants/belgian_constants.dart';
import 'package:film_sms/data/datasources/hive_storage.dart';
import 'package:film_sms/data/models/contact.dart';
import 'package:film_sms/data/models/conversation.dart';
import 'package:film_sms/data/models/message.dart';
import 'package:film_sms/data/models/message_template.dart';
import 'package:film_sms/data/repositories/contact_repository.dart';
import 'package:film_sms/data/repositories/template_repository.dart';
import 'package:film_sms/data/repositories/conversation_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeStorage extends HiveStorage {
  List<Contact> contacts;
  List<Conversation> conversations;
  List<MessageTemplate> templates;
  _FakeStorage(this.contacts, this.conversations, this.templates);

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

  @override
  Future<void> saveConversation(Conversation conversation) async {
    final i = conversations.indexWhere((c) => c.id == conversation.id);
    if (i >= 0) {
      conversations[i] = conversation;
    } else {
      conversations.add(conversation);
    }
  }

  @override
  Future<List<MessageTemplate>> getTemplates() async => templates;
  @override
  Future<void> saveTemplate(MessageTemplate template) async {
    final i = templates.indexWhere((t) => t.id == template.id);
    if (i >= 0) {
      templates[i] = template;
    } else {
      templates.add(template);
    }
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nl_BE', null);
    await initializeDateFormatting('nl', null);
  });

  testWidgets(
    'Detail AppBar: title is phone if no name; otherwise subtitle shows phone',
    (tester) async {
      final deLijn = Contact(
        name: '',
        phoneNumber: BelgianConstants.deLijnNumber,
        type: ContactType.transport,
        isDynamic: true,
      );
      final named = Contact(
        name: 'Mama',
        phoneNumber: '+32468123456',
        type: ContactType.family,
      );

      final now = DateTime.now();
      final storage = _FakeStorage(
        [deLijn, named],
        [
          Conversation(
            contactId: deLijn.id,
            messages: [
              Message(
                body: 'Hi',
                isIncoming: true,
                timestamp: now.subtract(const Duration(minutes: 5)),
                contactId: deLijn.id,
              ),
            ],
          ),
          Conversation(
            contactId: named.id,
            messages: [
              Message(
                body: 'Hello',
                isIncoming: true,
                timestamp: now.subtract(const Duration(minutes: 4)),
                contactId: named.id,
              ),
            ],
          ),
        ],
        [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hiveStorageProvider.overrideWithValue(storage),
            contactRepositoryProvider.overrideWithValue(
              ContactRepository(storage),
            ),
            templateRepositoryProvider.overrideWithValue(
              TemplateRepository(storage),
            ),
            conversationRepositoryProvider.overrideWithValue(
              ConversationRepository(storage, ContactRepository(storage)),
            ),
          ],
          child: const FilmSMSApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap into De Lijn (first tile) and check AppBar title (must be the number)
      // Tap into De Lijn tile (identified by its number)
      // If title is formatted with spaces, match by scanning
      Element? deLijnElement;
      for (final e in find.byType(ListTile).evaluate()) {
        final t = e.widget as ListTile;
        if (t.title is Text) {
          final s = ((t.title as Text).data ?? '').replaceAll(' ', '');
          if (s == BelgianConstants.deLijnNumber.replaceAll(' ', '')) {
            deLijnElement = e;
            break;
          }
        }
      }
      expect(deLijnElement != null, true);
      await tester.tap(find.byWidget(deLijnElement!.widget));
      await tester.pumpAndSettle();
      // Verify AppBar displays the number (allow spaces) in its title
      final normalized = BelgianConstants.deLijnNumber.replaceAll(' ', '');
      bool appBarShowsNumber = false;
      for (final e in find.byType(AppBar).evaluate()) {
        final w = e.widget as AppBar;
        final titleW = w.title;
        if (titleW is Text) {
          final s = (titleW.data ?? '').replaceAll(' ', '');
          if (s.contains(normalized)) {
            appBarShowsNumber = true;
            break;
          }
        }
      }
      expect(appBarShowsNumber, true);

      // Go back and open the named contact; check that subtitle contains a phone-looking value
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Find tile for named contact and open it
      Element? namedElement;
      for (final e in find.byType(ListTile).evaluate()) {
        final t = e.widget as ListTile;
        if (t.title is Text && (t.title as Text).data == 'Mama') {
          namedElement = e;
          break;
        }
      }
      expect(namedElement != null, true);
      await tester.tap(find.byWidget(namedElement!.widget));
      await tester.pumpAndSettle();

      // Subtitle check: look for any label-like small text with +32
      bool foundSubtitle = false;
      for (final e in find.byType(AppBar).evaluate()) {
        final w = e.widget as AppBar;
        final bottom = w.bottom;
        if (bottom is PreferredSizeWidget) {
          // The bottom child is added via PreferredSize -> Padding -> Text
          // Scan descendants under the AppBar for a Text starting with +32
          final appBarFinder = find.ancestor(
            of: find.byType(Text),
            matching: find.byType(AppBar),
          );
          for (final te in appBarFinder.evaluate()) {
            // For each Text under AppBar
            final textWidgets = find
                .descendant(
                  of: find.byWidget(te.widget),
                  matching: find.byType(Text),
                )
                .evaluate();
            for (final tw in textWidgets) {
              final tx = tw.widget as Text;
              final s = tx.data ?? '';
              if (s.startsWith('+32')) {
                foundSubtitle = true;
                break;
              }
            }
          }
        }
      }
      expect(foundSubtitle, true);
    },
  );
}
