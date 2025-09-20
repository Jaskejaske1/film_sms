import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String? avatar; // Optional avatar path/url

  @HiveField(4)
  final ContactType type;

  @HiveField(5)
  final bool isDynamic; // True if this contact has dynamic message templates

  Contact({
    String? id,
    required this.name,
    required this.phoneNumber,
    this.avatar,
    required this.type,
    this.isDynamic = false,
  }) : id = id ?? const Uuid().v4();

  Contact copyWith({
    String? name,
    String? phoneNumber,
    String? avatar,
    ContactType? type,
    bool? isDynamic,
  }) {
    return Contact(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      isDynamic: isDynamic ?? this.isDynamic,
    );
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phoneNumber: $phoneNumber, type: $type, isDynamic: $isDynamic)';
  }
}

@HiveType(typeId: 1)
enum ContactType {
  @HiveField(0)
  family,

  @HiveField(1)
  work,

  @HiveField(2)
  friends,

  @HiveField(3)
  services, // NMBS, bpost, utilities

  @HiveField(4)
  business, // Restaurants, shops

  @HiveField(5)
  government, // City services, official

  @HiveField(6)
  transport, // De Lijn, parking, etc.
}
