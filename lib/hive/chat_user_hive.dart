import 'package:hive/hive.dart';

part 'chat_user_hive.g.dart';

@HiveType(typeId: 0)
class ChatUserHive extends HiveObject {
  @HiveField(0)
  late String image;

  @HiveField(1)
  late String about;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String createdAt;

  @HiveField(4)
  late bool isOnline;

  @HiveField(5)
  late String id;

  @HiveField(6)
  late String lastActive;

  @HiveField(7)
  late String phone;

  @HiveField(8)
  late String pushToken;

  ChatUserHive({
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

  factory ChatUserHive.fromJson(Map<String, dynamic> json) {
    return ChatUserHive(
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
