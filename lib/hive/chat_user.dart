import 'package:hive/hive.dart';

// part 'chat_user.g.dart';

@HiveType(typeId: 0)
class ChatUser extends HiveObject {
  @HiveField(0)
  String image;

  @HiveField(1)
  String about;

  @HiveField(2)
  String name;

  @HiveField(3)
  String createdAt;

  @HiveField(4)
  bool isOnline;

  @HiveField(5)
  String id;

  @HiveField(6)
  String lastActive;

  @HiveField(7)
  String phone;

  @HiveField(8)
  String pushToken;

  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.phone,
    required this.pushToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      image: json['image'] ?? '',
      about: json['about'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      isOnline: json['is_online'] ?? false,
      id: json['id'] ?? '',
      lastActive: json['last_active'] ?? '',
      phone: json['phone'] ?? '',
      pushToken: json['push_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['phone'] = phone;
    data['push_token'] = pushToken;
    return data;
  }
}
