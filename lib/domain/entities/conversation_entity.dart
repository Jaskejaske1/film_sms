import 'message_entity.dart';

class ConversationEntity {
  final String id;
  final String contactId;
  final List<MessageEntity> messages;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isPinned;

  const ConversationEntity({
    required this.id,
    required this.contactId,
    required this.messages,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isPinned,
  });

  MessageEntity? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  String get lastMessageText {
    final last = lastMessage;
    if (last == null) return '';
    return last.body;
  }

  ConversationEntity copyWith({
    String? contactId,
    List<MessageEntity>? messages,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isPinned,
  }) {
    return ConversationEntity(
      id: id,
      contactId: contactId ?? this.contactId,
      messages: messages ?? List.from(this.messages),
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  ConversationEntity addMessage(MessageEntity message) {
    final updatedMessages = List<MessageEntity>.from(messages)..add(message);
    return copyWith(
      messages: updatedMessages,
      lastMessageTime: message.timestamp,
      unreadCount: message.isIncoming ? unreadCount + 1 : 0,
    );
  }

  ConversationEntity markAsRead() {
    return copyWith(unreadCount: 0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
