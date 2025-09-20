import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'message_template.g.dart';

@HiveType(typeId: 5)
class MessageTemplate extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name; // "De Lijn Bus Ticket"

  @HiveField(2)
  final String description; // "Generates Belgian bus ticket SMS"

  @HiveField(3)
  final String template; // Template string with {{variables}}

  @HiveField(4)
  final List<TemplateVariable> variables;

  @HiveField(5)
  final String contactId; // Which contact this template belongs to

  @HiveField(6)
  final bool isActive;

  MessageTemplate({
    String? id,
    required this.name,
    required this.description,
    required this.template,
    required this.variables,
    required this.contactId,
    this.isActive = true,
  }) : id = id ?? const Uuid().v4();

  MessageTemplate copyWith({
    String? name,
    String? description,
    String? template,
    List<TemplateVariable>? variables,
    String? contactId,
    bool? isActive,
  }) {
    return MessageTemplate(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      template: template ?? this.template,
      variables: variables ?? this.variables,
      contactId: contactId ?? this.contactId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'MessageTemplate(id: $id, name: $name, contactId: $contactId, isActive: $isActive)';
  }
}

@HiveType(typeId: 6)
class TemplateVariable extends HiveObject {
  @HiveField(0)
  @override
  final String key; // "price", "expiry_time", etc.

  @HiveField(1)
  final String displayName; // "Price (Euro)"

  @HiveField(2)
  final VariableType type;

  @HiveField(3)
  final String? defaultValue;

  @HiveField(4)
  final Map<String, dynamic>? config; // Additional configuration

  TemplateVariable({
    required this.key,
    required this.displayName,
    required this.type,
    this.defaultValue,
    this.config,
  });

  TemplateVariable copyWith({
    String? key,
    String? displayName,
    VariableType? type,
    String? defaultValue,
    Map<String, dynamic>? config,
  }) {
    return TemplateVariable(
      key: key ?? this.key,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      defaultValue: defaultValue ?? this.defaultValue,
      config: config ?? this.config,
    );
  }
}

@HiveType(typeId: 7)
enum VariableType {
  @HiveField(0)
  userInput, // User enters value

  @HiveField(1)
  static, // Fixed value

  @HiveField(2)
  timeCalculator, // Current time + offset

  @HiveField(3)
  dateFormatter, // Current date formatted

  @HiveField(4)
  codeGenerator, // Random code generation

  @HiveField(5)
  priceFormatter, // Euro formatting
}
