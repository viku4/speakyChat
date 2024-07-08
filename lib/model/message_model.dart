import 'dart:math';

import '../offline/message_hive.dart';

class Message {
  var starred;
  var pinned;
  var fromName;
  var toName;
  var fromPic;
  var chatId;
  var isLocal;

  Message({
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
    this.isLocal
  });

  late final String toId;
  late final String msg;
  late final String read;
  late final String delivered;
  late final String fromId;
  late final String sent;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    chatId = json['chatId'].toString();
    fromName = json['fromName'].toString();
    toName = json['toName'].toString();
    fromPic = json['fromPic'].toString();

    if(json['starred']!=null){
      starred = json['starred'].toString();
    }

    if(json['pinned']!=null){
      pinned = json['pinned'];
    }
    msg = json['msg'].toString();
    read = json['read'].toString();
    delivered = json['delivered'].toString();
    if(json['type'].toString() == "image"){
      type = Type.image;
    }else if(json['type'].toString() == "document"){
      type = Type.document;
    }else if(json['type'].toString() == "audio"){
      type = Type.audio;
    }else if(json['type'].toString() == "video"){
      type = Type.video;
    }else if(json['type'].toString() == "location"){
      type = Type.location;
    }else if(json['type'].toString() == "contact"){
      type = Type.contact;
    }else{
      type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    }
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
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
    return data;
  }

  MessageHive toHiveMessage() {
    return MessageHive(
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
    );
  }

  MessageType _convertType(Type type) {
    switch (type) {
      case Type.image:
        return MessageType.image;
      case Type.document:
        return MessageType.document;
      case Type.audio:
        return MessageType.audio;
      case Type.video:
        return MessageType.video;
      case Type.location:
        return MessageType.location;
      case Type.contact:
        return MessageType.contact;
      default:
        return MessageType.text;
    }
  }
}

enum Type { text, image, audio, video, document, location, contact }