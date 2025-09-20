import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 4)
class Conversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String contactId;

  @HiveField(2)
  final List<Message> messages;

  @HiveField(3)
  final DateTime lastMessageTime;

  @HiveField(4)
  final int unreadCount;

  @HiveField(5)
  final bool isPinned;

  Conversation({
    String? id,
    required this.contactId,
    List<Message>? messages,
    DateTime? lastMessageTime,
    this.unreadCount = 0,
    this.isPinned = false,
  }) : id = id ?? const Uuid().v4(),
       messages = messages ?? [],
       lastMessageTime =
           lastMessageTime ??
           ((messages != null && messages.isNotEmpty)
               ? messages.last.timestamp
               : DateTime.now());

  // Get the last message for preview
  Message? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  // Get last message text for UI
  String get lastMessageText {
    final last = lastMessage;
    if (last == null) return '';
    return last.body;
  }

  Conversation copyWith({
    String? contactId,
    List<Message>? messages,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isPinned,
  }) {
    return Conversation(
      id: id,
      contactId: contactId ?? this.contactId,
      messages: messages ?? List.from(this.messages),
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  // Add message to conversation
  Conversation addMessage(Message message) {
    final updatedMessages = List<Message>.from(messages)..add(message);
    return copyWith(
      messages: updatedMessages,
      lastMessageTime: message.timestamp,
      unreadCount: message.isIncoming ? unreadCount + 1 : unreadCount,
    );
  }

  // Mark as read
  Conversation markAsRead() {
    return copyWith(unreadCount: 0);
  }

  @override
  String toString() {
    return 'Conversation(id: $id, contactId: $contactId, messagesCount: ${messages.length}, unreadCount: $unreadCount)';
  }
}
