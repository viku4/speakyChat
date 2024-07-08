import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speaky_chat/index.dart';

import '../contact/button_card.dart';
import '../model/chat_model.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {

  ChatModel? sourceChat;
  List<ChatModel> chatmodels = [
    // ChatModel(
    //   name: "User 1",
    //   isGroup: false,
    //   currentMessage: "Hi",
    //   time: "11:00",
    //   icon: "person.svg",
    //   id: '1',
    // ),
    // ChatModel(
    //   name: "User 2",
    //   isGroup: false,
    //   currentMessage: "Hey",
    //   time: "11:00",
    //   icon: "person.svg",
    //   id: '2',
    // ),

    // ChatModel(
    //   name: "User 3",
    //   isGroup: false,
    //   currentMessage: "Hello",
    //   time: "11:00",
    //   icon: "person.svg",
    //   id: 3,
    // ),
    //
    // ChatModel(
    //   name: "User 4",
    //   isGroup: false,
    //   currentMessage: "Hyy",
    //   time: "11:00",
    //   icon: "person.svg",
    //   id: 4,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: ListView.builder(
              itemCount: chatmodels.length,
              itemBuilder: (contex, index) => InkWell(
                onTap: () {
                  sourceChat = chatmodels.removeAt(index);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => HomePageWidget(
                            chatmodels: chatmodels,
                            sourchat: sourceChat,
                          )
                      )
                  );
                },
                child: ButtonCard(
                  name: chatmodels[index].name,
                  icon: Icons.person,
                ),
              )
          ),
        ),
      ),
    );
  }
}
