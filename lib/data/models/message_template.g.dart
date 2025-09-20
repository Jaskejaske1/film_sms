// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTemplateAdapter extends TypeAdapter<MessageTemplate> {
  @override
  final int typeId = 5;

  @override
  MessageTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageTemplate(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      template: fields[3] as String,
      variables: (fields[4] as List).cast<TemplateVariable>(),
      contactId: fields[5] as String,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageTemplate obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.template)
      ..writeByte(4)
      ..write(obj.variables)
      ..writeByte(5)
      ..write(obj.contactId)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TemplateVariableAdapter extends TypeAdapter<TemplateVariable> {
  @override
  final int typeId = 6;

  @override
  TemplateVariable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemplateVariable(
      key: fields[0] as String,
      displayName: fields[1] as String,
      type: fields[2] as VariableType,
      defaultValue: fields[3] as String?,
      config: (fields[4] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, TemplateVariable obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.defaultValue)
      ..writeByte(4)
      ..write(obj.config);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateVariableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VariableTypeAdapter extends TypeAdapter<VariableType> {
  @override
  final int typeId = 7;

  @override
  VariableType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VariableType.userInput;
      case 1:
        return VariableType.static;
      case 2:
        return VariableType.timeCalculator;
      case 3:
        return VariableType.dateFormatter;
      case 4:
        return VariableType.codeGenerator;
      case 5:
        return VariableType.priceFormatter;
      default:
        return VariableType.userInput;
    }
  }

  @override
  void write(BinaryWriter writer, VariableType obj) {
    switch (obj) {
      case VariableType.userInput:
        writer.writeByte(0);
        break;
      case VariableType.static:
        writer.writeByte(1);
        break;
      case VariableType.timeCalculator:
        writer.writeByte(2);
        break;
      case VariableType.dateFormatter:
        writer.writeByte(3);
        break;
      case VariableType.codeGenerator:
        writer.writeByte(4);
        break;
      case VariableType.priceFormatter:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariableTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
