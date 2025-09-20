class MessageEntity {
  final String id;
  final String body;
  final DateTime timestamp;
  final bool isIncoming;
  final String contactId;
  final MessageTypeEntity type;
  final bool isRead;
  final String? templateId;

  const MessageEntity({
    required this.id,
    required this.body,
    required this.timestamp,
    required this.isIncoming,
    required this.contactId,
    required this.type,
    required this.isRead,
    this.templateId,
  });

  MessageEntity copyWith({
    String? body,
    DateTime? timestamp,
    bool? isIncoming,
    String? contactId,
    MessageTypeEntity? type,
    bool? isRead,
    String? templateId,
  }) {
    return MessageEntity(
      id: id,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isIncoming: isIncoming ?? this.isIncoming,
      contactId: contactId ?? this.contactId,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      templateId: templateId ?? this.templateId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum MessageTypeEntity { text, template, deLijn, parking, service }
