// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageHiveAdapter extends TypeAdapter<MessageHive> {
  @override
  final int typeId = 0;

  @override
  MessageHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageHive(
      toId: fields[0] as String,
      chatId: fields[1] as dynamic,
      msg: fields[2] as String,
      read: fields[3] as String,
      type: fields[12] as MessageType,
      fromId: fields[5] as String,
      sent: fields[6] as String,
      starred: fields[7] as dynamic,
      pinned: fields[8] as dynamic,
      fromName: fields[9] as dynamic,
      fromPic: fields[11] as dynamic,
      delivered: fields[4] as String,
      toName: fields[10] as dynamic,
      isLocal: fields[13] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, MessageHive obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.toId)
      ..writeByte(1)
      ..write(obj.chatId)
      ..writeByte(2)
      ..write(obj.msg)
      ..writeByte(3)
      ..write(obj.read)
      ..writeByte(4)
      ..write(obj.delivered)
      ..writeByte(5)
      ..write(obj.fromId)
      ..writeByte(6)
      ..write(obj.sent)
      ..writeByte(7)
      ..write(obj.starred)
      ..writeByte(8)
      ..write(obj.pinned)
      ..writeByte(9)
      ..write(obj.fromName)
      ..writeByte(10)
      ..write(obj.toName)
      ..writeByte(11)
      ..write(obj.fromPic)
      ..writeByte(12)
      ..write(obj.type)
      ..writeByte(13)
      ..write(obj.isLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 1;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.text;
      case 1:
        return MessageType.image;
      case 2:
        return MessageType.audio;
      case 3:
        return MessageType.video;
      case 4:
        return MessageType.document;
      case 5:
        return MessageType.location;
      case 6:
        return MessageType.contact;
      default:
        return MessageType.text;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.text:
        writer.writeByte(0);
        break;
      case MessageType.image:
        writer.writeByte(1);
        break;
      case MessageType.audio:
        writer.writeByte(2);
        break;
      case MessageType.video:
        writer.writeByte(3);
        break;
      case MessageType.document:
        writer.writeByte(4);
        break;
      case MessageType.location:
        writer.writeByte(5);
        break;
      case MessageType.contact:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
