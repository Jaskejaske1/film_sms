import '../entities/conversation_entity.dart';
import '../entities/contact_entity.dart';
import '../entities/message_entity.dart'; // Add this import
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/contact_repository.dart';

class ManageConversationsUseCase {
  final ConversationRepository _conversationRepository;
  final ContactRepository _contactRepository;

  ManageConversationsUseCase(
    this._conversationRepository,
    this._contactRepository,
  );

  // Get all conversations with contact info
  Future<List<ConversationWithContact>> getConversationsWithContacts() async {
    final conversations = await _conversationRepository
        .getConversationsSorted();
    final contacts = await _contactRepository.getAllContacts();

    return conversations.map((conversation) {
      final contact = contacts.firstWhere(
        (c) => c.id == conversation.contactId,
        orElse: () => throw Exception('Contact not found for conversation'),
      );

      return ConversationWithContact(
        conversation: _mapToEntity(conversation),
        contact: _mapContactToEntity(contact),
      );
    }).toList();
  }

  // Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    await _conversationRepository.markConversationAsRead(conversationId);
  }

  // Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    await _conversationRepository.deleteConversation(conversationId);
  }

  // Helper to map data model to entity
  ConversationEntity _mapToEntity(conversation) {
    return ConversationEntity(
      id: conversation.id,
      contactId: conversation.contactId,
      messages: conversation.messages
          .map(
            (m) => MessageEntity(
              id: m.id,
              body: m.body,
              timestamp: m.timestamp,
              isIncoming: m.isIncoming,
              contactId: m.contactId,
              type: MessageTypeEntity.values[m.type.index],
              isRead: m.isRead,
              templateId: m.templateId,
            ),
          )
          .toList(),
      lastMessageTime: conversation.lastMessageTime,
      unreadCount: conversation.unreadCount,
      isPinned: conversation.isPinned,
    );
  }

  ContactEntity _mapContactToEntity(contact) {
    return ContactEntity(
      id: contact.id,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      avatar: contact.avatar,
      type: ContactTypeEntity.values[contact.type.index],
      isDynamic: contact.isDynamic,
    );
  }
}

// Helper class to combine conversation with contact data
class ConversationWithContact {
  final ConversationEntity conversation;
  final ContactEntity contact;

  const ConversationWithContact({
    required this.conversation,
    required this.contact,
  });
}
