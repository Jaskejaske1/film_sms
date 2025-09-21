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
  Future<void> hardReset() async {
    contacts = [];
    conversations = [];
    templates = [];
  }

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
    'List title uses phone when no name; shows phone subtitle when name exists',
    (tester) async {
      final deLijn = Contact(
        name: '',
        phoneNumber: BelgianConstants.deLijnNumber,
        type: ContactType.transport,
        isDynamic: true,
      );
      final mama = Contact(
        name: 'Mama',
        phoneNumber: '+32468123456',
        type: ContactType.family,
      );

      final now = DateTime.now();
      final storage = _FakeStorage(
        [deLijn, mama],
        [
          Conversation(
            contactId: deLijn.id,
            messages: [
              Message(
                body: 'Ticket info',
                isIncoming: true,
                timestamp: now.subtract(const Duration(minutes: 10)),
                contactId: deLijn.id,
              ),
            ],
          ),
          Conversation(
            contactId: mama.id,
            messages: [
              Message(
                body: 'Dag!',
                isIncoming: true,
                timestamp: now.subtract(const Duration(minutes: 9)),
                contactId: mama.id,
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

      // De Lijn tile should have its title equal to the phone number (normalize spaces)
      final normalized = BelgianConstants.deLijnNumber.replaceAll(' ', '');
      bool foundDeLijnTitle = false;
      for (final e in find.byType(ListTile).evaluate()) {
        final t = e.widget as ListTile;
        if (t.title is Text) {
          final text = (t.title as Text).data ?? '';
          if (text.replaceAll(' ', '') == normalized) {
            foundDeLijnTitle = true;
            break;
          }
        }
      }
      expect(foundDeLijnTitle, true);

      // Find the tile for 'Mama' and expect a subtitle that contains a phone number string (+32...)
      bool mamaHasPhoneSubtitle = false;
      for (final e in find.byType(ListTile).evaluate()) {
        final t = e.widget as ListTile;
        if (t.title is Text && (t.title as Text).data == 'Mama') {
          final sub = t.subtitle;
          if (sub is Column) {
            for (final child in sub.children) {
              if (child is Text && (child.data ?? '').startsWith('+32')) {
                mamaHasPhoneSubtitle = true;
              }
            }
          }
        }
      }
      expect(mamaHasPhoneSubtitle, true);
    },
  );
}
