import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../datasources/hive_storage.dart';
import '../mock_data/belgian_conversations.dart';
import 'contact_repository.dart';

class ConversationRepository {
  final HiveStorage _storage;
  final ContactRepository _contactRepository;

  ConversationRepository(this._storage, this._contactRepository);

  Future<List<Conversation>> getAllConversations() async {
    try {
      final conversations = await _storage.getConversations();
      if (conversations.isEmpty) {
        // First time - populate with Belgian mock data
        final contacts = await _contactRepository.getAllContacts();
        final mockConversations = BelgianConversationsData.getAllConversations(
          contacts,
        );
        await _storage.saveConversations(mockConversations);
        return mockConversations;
      }
      // Normalize: ensure messages are sorted and lastMessageTime matches last message
      final normalized = <Conversation>[];
      for (final c in conversations) {
        final sorted = List<Message>.from(c.messages)
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        final lastTs = sorted.isNotEmpty
            ? sorted.last.timestamp
            : c.lastMessageTime;
        if (!identical(sorted, c.messages) || c.lastMessageTime != lastTs) {
          final updated = c.copyWith(messages: sorted, lastMessageTime: lastTs);
          normalized.add(updated);
          await _storage.saveConversation(updated);
        } else {
          normalized.add(c);
        }
      }
      return normalized;
    } catch (e) {
      // Fallback to mock data
      final contacts = await _contactRepository.getAllContacts();
      return BelgianConversationsData.getAllConversations(contacts);
    }
  }

  Future<Conversation?> getConversationById(String id) async {
    final conversations = await getAllConversations();
    try {
      return conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Conversation?> getConversationByContactId(String contactId) async {
    final conversations = await getAllConversations();
    try {
      return conversations.firstWhere((c) => c.contactId == contactId);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveConversation(Conversation conversation) async {
    await _storage.saveConversation(conversation);
  }

  Future<void> addMessageToConversation(
    String contactId,
    Message message,
  ) async {
    final conversations = await getAllConversations();
    final conversationIndex = conversations.indexWhere(
      (c) => c.contactId == contactId,
    );

    if (conversationIndex >= 0) {
      // Update existing conversation
      final updatedConversation = conversations[conversationIndex].addMessage(
        message,
      );
      conversations[conversationIndex] = updatedConversation;
      await _storage.saveConversation(updatedConversation);
    } else {
      // Create new conversation
      final newConversation = Conversation(
        contactId: contactId,
        messages: [message],
        lastMessageTime: message.timestamp,
        unreadCount: message.isIncoming ? 1 : 0,
      );
      await _storage.saveConversation(newConversation);
    }
  }

  Future<void> markConversationAsRead(String conversationId) async {
    final conversation = await getConversationById(conversationId);
    if (conversation != null) {
      final updatedConversation = conversation.markAsRead();
      await _storage.saveConversation(updatedConversation);
    }
  }

  Future<void> deleteConversation(String id) async {
    await _storage.deleteConversation(id);
  }

  // Get conversations sorted by last message time
  Future<List<Conversation>> getConversationsSorted() async {
    final conversations = await getAllConversations();
    conversations.sort((a, b) {
      final cmp = b.lastMessageTime.compareTo(a.lastMessageTime);
      if (cmp != 0) return cmp;
      // Tiebreaker: stable by id to prevent visual swaps when equal
      return a.id.compareTo(b.id);
    });
    return conversations;
  }
}

// Provider
final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  final contactRepository = ref.watch(contactRepositoryProvider);
  return ConversationRepository(storage, contactRepository);
});
