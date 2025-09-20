// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final int typeId = 0;

  @override
  Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contact(
      id: fields[0] as String?,
      name: fields[1] as String,
      phoneNumber: fields[2] as String,
      avatar: fields[3] as String?,
      type: fields[4] as ContactType,
      isDynamic: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.avatar)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isDynamic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContactTypeAdapter extends TypeAdapter<ContactType> {
  @override
  final int typeId = 1;

  @override
  ContactType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContactType.family;
      case 1:
        return ContactType.work;
      case 2:
        return ContactType.friends;
      case 3:
        return ContactType.services;
      case 4:
        return ContactType.business;
      case 5:
        return ContactType.government;
      case 6:
        return ContactType.transport;
      default:
        return ContactType.family;
    }
  }

  @override
  void write(BinaryWriter writer, ContactType obj) {
    switch (obj) {
      case ContactType.family:
        writer.writeByte(0);
        break;
      case ContactType.work:
        writer.writeByte(1);
        break;
      case ContactType.friends:
        writer.writeByte(2);
        break;
      case ContactType.services:
        writer.writeByte(3);
        break;
      case ContactType.business:
        writer.writeByte(4);
        break;
      case ContactType.government:
        writer.writeByte(5);
        break;
      case ContactType.transport:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
