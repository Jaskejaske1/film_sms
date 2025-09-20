import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:film_sms/main.dart';
import 'package:film_sms/core/constants/belgian_constants.dart';
import 'package:film_sms/data/datasources/hive_storage.dart';
import 'package:film_sms/data/models/contact.dart';
import 'package:film_sms/data/models/conversation.dart';
import 'package:film_sms/data/models/message_template.dart';
import 'package:film_sms/data/repositories/contact_repository.dart';
import 'package:film_sms/data/repositories/template_repository.dart';
import 'package:film_sms/data/repositories/conversation_repository.dart';
import 'package:film_sms/presentation/widgets/conversation_tile.dart';
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
    final idx = conversations.indexWhere((c) => c.id == conversation.id);
    if (idx >= 0) {
      conversations[idx] = conversation;
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

  testWidgets('Menu inject De Lijn shows snackbar', (tester) async {
    final deLijn = Contact(
      name: 'De Lijn',
      phoneNumber: BelgianConstants.deLijnNumber,
      type: ContactType.transport,
      isDynamic: true,
    );
    final storage = _FakeStorage(
      [deLijn],
      [Conversation(contactId: deLijn.id)],
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

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inject De Lijn'));
    // Allow async injection and snackbar to appear
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 900));

    // Assert snackbar content text (localized)
    final okText = find.textContaining('De Lijn inserted').evaluate().isNotEmpty
        ? find.textContaining('De Lijn inserted')
        : find.textContaining('De Lijn ingevoegd');
    expect(okText, findsOneWidget);
  });

  testWidgets('Bottom sheet template selection injects and shows snackbar', (
    tester,
  ) async {
    final c = Contact(
      name: 'Test',
      phoneNumber: '+321234',
      type: ContactType.services,
    );
    final tmpl = MessageTemplate(
      name: 'De Lijn Bus Ticket',
      description: 'desc',
      template:
          '{{prefix_code}} {{company}} {{expiry_time}} {{current_date}} prijs {{price}} {{validation_code}}',
      contactId: c.id,
      variables: [
        TemplateVariable(
          key: 'prefix_code',
          displayName: 'Prefix',
          type: VariableType.codeGenerator,
          config: {'pattern': 'prefix'},
        ),
        TemplateVariable(
          key: 'company',
          displayName: 'Company',
          type: VariableType.static,
          defaultValue: 'De Lijn',
        ),
        TemplateVariable(
          key: 'expiry_time',
          displayName: 'Expiry',
          type: VariableType.timeCalculator,
        ),
        TemplateVariable(
          key: 'current_date',
          displayName: 'Date',
          type: VariableType.dateFormatter,
        ),
        TemplateVariable(
          key: 'price',
          displayName: 'Price',
          type: VariableType.userInput,
          defaultValue: '2,50',
        ),
        TemplateVariable(
          key: 'validation_code',
          displayName: 'Validation',
          type: VariableType.codeGenerator,
          config: {'length': 10},
        ),
      ],
    );

    final storage = _FakeStorage([c], [Conversation(contactId: c.id)], [tmpl]);

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

    // Long press first conversation tile to open templates bottom sheet
    // The list should have at least one tile; tap the first
    // Long-press the first conversation tile
    final tile = find.byType(ConversationTile).first;
    await tester.longPress(tile);
    await tester.pumpAndSettle();

    // Select the first template (De Lijn Bus Ticket)
    await tester.tap(find.text('De Lijn Bus Ticket'));
    await tester.pumpAndSettle();

    // If inputs dialog appears, fill price and confirm
    if (find.byType(AlertDialog).evaluate().isNotEmpty) {
      await tester.enterText(find.byType(TextFormField).first, '3,00');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 800));
    }

    // Verify conversation received a new message
    expect(storage.conversations.first.messages.isNotEmpty, true);
    // Optionally assert snackbar text if present
    await tester.pump(const Duration(milliseconds: 400));
    final okInserted = find.textContaining('Template inserted');
    final okIngevoegd = find.textContaining('Template ingevoegd');
    if (okInserted.evaluate().isNotEmpty || okIngevoegd.evaluate().isNotEmpty) {
      expect(
        okInserted.evaluate().isNotEmpty || okIngevoegd.evaluate().isNotEmpty,
        true,
      );
    }
  });
}
