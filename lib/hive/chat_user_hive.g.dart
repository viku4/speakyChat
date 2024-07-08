// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatUserHiveAdapter extends TypeAdapter<ChatUserHive> {
  @override
  final int typeId = 0;

  @override
  ChatUserHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatUserHive(
      image: fields[0] as String,
      about: fields[1] as String,
      name: fields[2] as String,
      createdAt: fields[3] as String,
      isOnline: fields[4] as bool,
      id: fields[5] as String,
      lastActive: fields[6] as String,
      phone: fields[7] as String,
      pushToken: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatUserHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.about)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isOnline)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.lastActive)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.pushToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUserHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
