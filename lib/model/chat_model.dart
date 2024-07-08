class ChatModel {
  String? name;
  String? icon;
  bool? isGroup;
  String? time;
  String? currentMessage;
  String? status;
  bool? select = false;
  String? id;
  ChatModel({
    this.name,
    this.icon,
    this.isGroup,
    this.time,
    this.currentMessage,
    this.status,
    this.select = false,
    this.id,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "icon": icon,
    "isGroup": isGroup,
    "time": time,
    "currentMessage": currentMessage,
    "status": status,
    "select": select,
    "id": id,
  };

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    name: json["name"],
    icon: json["icon"],
    isGroup: json["isGroup"],
    time: json["time"],
    currentMessage: json["currentMessage"],
    status: json["status"],
    select: json["select"] ?? false, // Handle null value for select
    id: json["id"],
  );
}