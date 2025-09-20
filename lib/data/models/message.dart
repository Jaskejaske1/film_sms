import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'message.g.dart';

@HiveType(typeId: 2)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final bool isIncoming;

  @HiveField(4)
  final String contactId;

  @HiveField(5)
  final MessageType type;

  @HiveField(6)
  final bool isRead;

  @HiveField(7)
  final String? templateId; // If generated from template

  Message({
    String? id,
    required this.body,
    required this.timestamp,
    required this.isIncoming,
    required this.contactId,
    this.type = MessageType.text,
    this.isRead = false,
    this.templateId,
  }) : id = id ?? const Uuid().v4();

  Message copyWith({
    String? body,
    DateTime? timestamp,
    bool? isIncoming,
    String? contactId,
    MessageType? type,
    bool? isRead,
    String? templateId,
  }) {
    return Message(
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
  String toString() {
    return 'Message(id: $id, body: $body, isIncoming: $isIncoming, type: $type, templateId: $templateId)';
  }
}

@HiveType(typeId: 3)
enum MessageType {
  @HiveField(0)
  text,

  @HiveField(1)
  template, // Generated from template

  @HiveField(2)
  deLijn, // Specific De Lijn bus ticket

  @HiveField(3)
  parking, // Future parking messages

  @HiveField(4)
  service, // NMBS, bpost, etc.
}
