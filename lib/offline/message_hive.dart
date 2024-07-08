import 'package:hive/hive.dart';

import '../model/message_model.dart';

part 'message_hive.g.dart';

@HiveType(typeId: 0)
class MessageHive {
  @HiveField(0)
  late final String toId;

  @HiveField(1)
  var chatId;

  @HiveField(2)
  late final String msg;

  @HiveField(3)
  late final String read;

  @HiveField(4)
  late final String delivered;

  @HiveField(5)
  late final String fromId;

  @HiveField(6)
  late final String sent;

  @HiveField(7)
  var starred;

  @HiveField(8)
  var pinned;

  @HiveField(9)
  var fromName;

  @HiveField(10)
  var toName;

  @HiveField(11)
  var fromPic;

  @HiveField(12)
  late final MessageType type;

  @HiveField(13)
  var isLocal;

  MessageHive({
    required this.toId,
    this.chatId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    this.starred,
    this.pinned,
    this.fromName,
    this.fromPic,
    required this.delivered,
    this.toName,
    this.isLocal,
  });

  factory MessageHive.fromJson(Map<String, dynamic> json) {
    return MessageHive(
      toId: json['toId'].toString(),
      chatId: json['chatId']?.toString(),
      msg: json['msg'].toString(),
      read: json['read'].toString(),
      delivered: json['delivered'].toString(),
      type: _stringToType(json['type'].toString()),
      fromId: json['fromId'].toString(),
      sent: json['sent'].toString(),
      starred: json['starred']?.toString(),
      pinned: json['pinned'],
      fromName: json['fromName']?.toString(),
      toName: json['toName']?.toString(),
      fromPic: json['fromPic']?.toString(),
      isLocal: json['isLocal']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['chatId'] = chatId;
    data['msg'] = msg;
    data['read'] = read;
    data['delivered'] = delivered;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    if (starred != null) {
      data['starred'] = starred;
    }
    if (pinned != null) {
      data['pinned'] = pinned;
    }
    if (fromName != null) {
      data['fromName'] = fromName;
    }
    if (toName != null) {
      data['toName'] = toName;
    }
    if (fromPic != null) {
      data['fromPic'] = fromPic;
    }
    if (isLocal != null) {
      data['isLocal'] = isLocal;
    }
    return data;
  }

  static MessageType _stringToType(String type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'document':
        return MessageType.document;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'location':
        return MessageType.location;
      case 'contact':
        return MessageType.contact;
      default:
        return MessageType.text;
    }
  }

  Message toMessage() {
    return Message(
      toId: toId,
      chatId: chatId,
      msg: msg,
      read: read,
      delivered: delivered,
      type: _convertType(type),
      fromId: fromId,
      sent: sent,
      starred: starred,
      pinned: pinned,
      fromName: fromName,
      toName: toName,
      fromPic: fromPic,
      isLocal: isLocal,
    );
  }

  Type _convertType(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Type.image;
      case MessageType.document:
        return Type.document;
      case MessageType.audio:
        return Type.audio;
      case MessageType.video:
        return Type.video;
      case MessageType.location:
        return Type.location;
      case MessageType.contact:
        return Type.contact;
      default:
        return Type.text;
    }
  }


}

@HiveType(typeId: 1)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  audio,
  @HiveField(3)
  video,
  @HiveField(4)
  document,
  @HiveField(5)
  location,
  @HiveField(6)
  contact,
}
