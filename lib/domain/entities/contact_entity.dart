// Domain entities are pure business objects without dependencies

class ContactEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatar;
  final ContactTypeEntity type;
  final bool isDynamic;

  const ContactEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.avatar,
    required this.type,
    required this.isDynamic,
  });

  ContactEntity copyWith({
    String? name,
    String? phoneNumber,
    String? avatar,
    ContactTypeEntity? type,
    bool? isDynamic,
  }) {
    return ContactEntity(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      isDynamic: isDynamic ?? this.isDynamic,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum ContactTypeEntity {
  family,
  work,
  friends,
  services,
  business,
  government,
  transport,
}
