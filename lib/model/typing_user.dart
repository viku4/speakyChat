class TypingUser {
  TypingUser({
    required this.isTyping
  });
  bool isTyping = false;

  TypingUser.fromJson(Map<String, dynamic> json) {
    isTyping = json['is_typing'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_typing'] = isTyping;
    return data;
  }
}