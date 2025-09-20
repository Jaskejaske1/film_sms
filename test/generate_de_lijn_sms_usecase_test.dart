import 'package:flutter_test/flutter_test.dart';
import 'package:film_sms/domain/usecases/generate_de_lijn_sms.dart';
import 'package:film_sms/data/repositories/conversation_repository.dart';
import 'package:film_sms/data/repositories/template_repository.dart';
import 'package:film_sms/data/repositories/contact_repository.dart';
import 'package:film_sms/data/datasources/hive_storage.dart';
import 'package:film_sms/core/constants/belgian_constants.dart';
import 'package:film_sms/data/models/contact.dart';
import 'package:film_sms/data/models/conversation.dart';
import 'package:film_sms/data/models/message_template.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeStorage extends HiveStorage {
  List<Contact> contacts;
  List<Conversation> conversations = [];
  List<MessageTemplate> templates = [];

  _FakeStorage(this.contacts);

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
    final idx = templates.indexWhere((t) => t.id == template.id);
    if (idx >= 0) {
      templates[idx] = template;
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
  group('GenerateDeLijnSMSUseCase', () {
    test('creates missing template and injects message', () async {
      final deLijn = Contact(
        name: 'De Lijn',
        phoneNumber: BelgianConstants.deLijnNumber,
        type: ContactType.transport,
        isDynamic: true,
      );
      final storage = _FakeStorage([deLijn]);
      // Pre-populate a conversation to avoid mock seeding that requires many contacts
      storage.conversations = [Conversation(contactId: deLijn.id)];
      final contactRepo = ContactRepository(storage);
      final conversationRepo = ConversationRepository(storage, contactRepo);
      final templateRepo = TemplateRepository(storage);

      final usecase = GenerateDeLijnSMSUseCase(
        conversationRepo,
        templateRepo,
        contactRepo,
      );

      // No templates exist initially
      expect(storage.templates.isEmpty, true);

      final msg = await usecase.generateAndInjectDeLijnSMS();

      // Template should have been created and used
      expect(storage.templates.isNotEmpty, true);
      final convs = await conversationRepo.getAllConversations();
      expect(convs.any((c) => c.contactId == deLijn.id), true);
      final conv = convs.firstWhere((c) => c.contactId == deLijn.id);
      expect(conv.messages.isNotEmpty, true);
      expect(msg.body.contains('De Lijn'), true);
      expect(msg.type.toString().toLowerCase().contains('delijn'), true);
    });

    test('validatePrice accepts comma and dot values', () {
      final storage = _FakeStorage([]);
      final contactRepo = ContactRepository(storage);
      final conversationRepo = ConversationRepository(storage, contactRepo);
      final templateRepo = TemplateRepository(storage);
      final usecase = GenerateDeLijnSMSUseCase(
        conversationRepo,
        templateRepo,
        contactRepo,
      );

      expect(usecase.validatePrice('2,50'), true);
      expect(usecase.validatePrice('3.1'), true);
      expect(usecase.validatePrice('0'), false);
      expect(usecase.validatePrice('abc'), false);
    });
  });
}
