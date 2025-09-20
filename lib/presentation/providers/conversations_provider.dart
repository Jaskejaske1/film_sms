import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/contact_repository.dart';
import '../../data/repositories/template_repository.dart';
import '../../data/models/contact.dart';
import '../../data/datasources/hive_storage.dart';
import '../../data/mock_data/belgian_contacts.dart';
import '../../data/mock_data/belgian_conversations.dart';
import '../../core/constants/belgian_constants.dart';
import '../../domain/usecases/generate_de_lijn_sms.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/inject_template_message.dart';
import '../../data/models/conversation.dart';
import '../../core/templates/message_template.dart';
import '../../data/models/message.dart';
import 'contacts_provider.dart';

// Initialize contacts and default templates (De Lijn)
final appInitProvider = FutureProvider<void>((ref) async {
  final contactsRepo = ref.read(contactRepositoryProvider);
  final templateRepo = ref.read(templateRepositoryProvider);

  final contacts = await contactsRepo.getAllContacts();

  Contact? deLijn = contacts.firstWhere(
    (c) => c.phoneNumber == BelgianConstants.deLijnNumber,
    orElse: () => Contact(
      name: 'De Lijn',
      phoneNumber: BelgianConstants.deLijnNumber,
      type: ContactType.transport,
      isDynamic: true,
    ),
  );

  if (!contacts.any((c) => c.phoneNumber == BelgianConstants.deLijnNumber)) {
    await contactsRepo.saveContact(deLijn);
    deLijn = (await contactsRepo.getContactByPhoneNumber(
      BelgianConstants.deLijnNumber,
    ));
  }

  if (deLijn != null) {
    await templateRepo.initializeDefaultTemplates(deLijn.id);
  }
});

// Conversations listing
final conversationsProvider = FutureProvider((ref) async {
  final repo = ref.watch(conversationRepositoryProvider);
  return repo.getConversationsSorted();
});

// Conversation by contact id (for detail screen)

// Reseed all data deterministically after a wipe
final reseedDataActionProvider = Provider<Future<void> Function()>((ref) {
  final storage = ref.read(hiveStorageProvider);
  final contactsRepo = ref.read(contactRepositoryProvider);
  final tmplRepo = ref.read(templateRepositoryProvider);
  return () async {
    await storage.hardReset();
    // Seed contacts first
    final contacts = BelgianContactsData.getAllContacts();
    await storage.saveContacts(contacts);
    // Seed conversations using saved contacts for correct ids
    final seededConversations = BelgianConversationsData.getAllConversations(
      contacts,
    );
    await storage.saveConversations(seededConversations);
    // Ensure De Lijn template exists for De Lijn contact
    final deLijn = await contactsRepo.getContactByPhoneNumber(
      BelgianConstants.deLijnNumber,
    );
    if (deLijn != null) {
      await tmplRepo.initializeDefaultTemplates(deLijn.id);
    }
    // Invalidate providers
    ref.invalidate(contactsProvider);
    ref.invalidate(conversationsProvider);
    ref.invalidate(appInitProvider);
  };
});
final conversationByContactIdProvider =
    FutureProvider.family<Conversation?, String>((ref, contactId) async {
      final repo = ref.watch(conversationRepositoryProvider);
      return repo.getConversationByContactId(contactId);
    });

// Use case provider to inject De Lijn message
final _useCaseProvider = Provider<GenerateDeLijnSMSUseCase>((ref) {
  final convRepo = ref.read(conversationRepositoryProvider);
  final tmplRepo = ref.read(templateRepositoryProvider);
  final contactRepo = ref.read(contactRepositoryProvider);
  return GenerateDeLijnSMSUseCase(convRepo, tmplRepo, contactRepo);
});

// Action: inject a De Lijn ticket (call the function returned)
final injectDeLijnActionProvider = Provider<Future<MessageEntity> Function()>((
  ref,
) {
  final uc = ref.read(_useCaseProvider);
  return () async {
    final entity = await uc.generateAndInjectDeLijnSMS();
    ref.invalidate(conversationsProvider);
    ref.invalidate(conversationByContactIdProvider(entity.contactId));
    return entity;
  };
});

// Use case for generic template injection (Phase 2 ready)
final _injectTemplateUseCaseProvider = Provider<InjectTemplateMessageUseCase>((
  ref,
) {
  final convRepo = ref.read(conversationRepositoryProvider);
  final tmplRepo = ref.read(templateRepositoryProvider);
  return InjectTemplateMessageUseCase(convRepo, tmplRepo);
});

// List templates for a contact
final templatesForContactProvider =
    FutureProvider.family<List<MessageTemplate>, String>((
      ref,
      contactId,
    ) async {
      final repo = ref.watch(templateRepositoryProvider);
      return repo.getTemplatesForContact(contactId);
    });

// Inject a chosen template
// Action: inject a selected template message
typedef InjectTemplateArgs = ({
  String contactId,
  String templateId,
  Map<String, String> userInputs,
});

final injectTemplateActionProvider =
    Provider<Future<MessageEntity> Function(InjectTemplateArgs args)>((ref) {
      final uc = ref.read(_injectTemplateUseCaseProvider);
      return (args) async {
        final entity = await uc.injectTemplateMessage(
          contactId: args.contactId,
          templateId: args.templateId,
          userInputs: args.userInputs,
        );
        ref.invalidate(conversationsProvider);
        ref.invalidate(conversationByContactIdProvider(args.contactId));
        return entity;
      };
    });

typedef SendMessageArgs = ({String contactId, String body});

// Action: send an outgoing message and refresh state
final sendMessageActionProvider =
    Provider<Future<void> Function(SendMessageArgs args)>((ref) {
      return (args) async {
        final repo = ref.read(conversationRepositoryProvider);
        final message = Message(
          body: args.body,
          timestamp: DateTime.now(),
          isIncoming: false,
          contactId: args.contactId,
        );
        await repo.addMessageToConversation(args.contactId, message);
        ref.invalidate(conversationsProvider);
        ref.invalidate(conversationByContactIdProvider(args.contactId));
      };
    });

// Action: mark a conversation as read and refresh state
final markAsReadActionProvider =
    Provider<Future<void> Function(String contactId)>((ref) {
      return (contactId) async {
        final repo = ref.read(conversationRepositoryProvider);
        final convo = await repo.getConversationByContactId(contactId);
        if (convo != null && convo.unreadCount > 0) {
          await repo.markConversationAsRead(convo.id);
          ref.invalidate(conversationsProvider);
          ref.invalidate(conversationByContactIdProvider(contactId));
        }
      };
    });
