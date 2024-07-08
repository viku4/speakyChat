import 'package:flutter/cupertino.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatProvider with ChangeNotifier {

  List<Message> chatList = [];
  // int callCount = 1;

  List<Message> get getChatList {
    return chatList;
  }

  void addRemoteMessage({required Message message}) {
    chatList.add(message);
    notifyListeners();
  }

  void addUserMessage({required Message message}) {
    chatList.add(message);
    notifyListeners();
  }

  void clearChat() {
    chatList.clear();
  }
}
