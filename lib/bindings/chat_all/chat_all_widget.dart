import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/contact/pages/contact_page.dart';
import 'package:speaky_chat/model/user_model.dart';

import '../../home_page/home_page_widget.dart';
import '../../model/chat_model.dart';
import '../../model/chat_user.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_all_model.dart';
import 'chat_user.dart';
import 'custom_card.dart';
export 'chat_all_model.dart';

class ChatAllWidget extends StatefulWidget {
  const ChatAllWidget({Key? key, this.chatmodels, this.sourchat})
      : super(key: key);
  final List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _ChatAllWidgetState createState() => _ChatAllWidgetState();
}

class _ChatAllWidgetState extends State<ChatAllWidget> {
  @override
  void initState() {
    super.initState();
    APIService.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if(message!.contains('pause')) APIService.updateActiveStatus(false);
      if(message.contains('inactive')) APIService.updateActiveStatus(false);
      if(message.contains('resume')) APIService.updateActiveStatus(true);
      return Future.value(message);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<ChatModel> list = [];

    List<ChatUser> _list = [];

    // for storing searched items
    final List<ChatUser> _searchList = [];
    // for storing search status
    bool isSearching = false;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(() => ContactsPage());
        },
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 8.0,
        child: Icon(
          Icons.wechat_outlined,
          color: FlutterFlowTheme.of(context).primaryBackground,
          size: 24.0,
        ),
      ),
      body: StreamBuilder(
        stream: APIService.getMyUsersId(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
            final data = snapshot.data?.docs;
            _list = data
                ?.map((e) => ChatUser.fromJson(e.data()))
                .toList() ??
                [];
            if (_list.isNotEmpty) {
              return ListView.builder(
                  itemCount:
                  false ? _searchList.length : _list.length,
                  padding: EdgeInsets.only(
                      top:
                      MediaQuery.of(context).size.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                        user: false
                            ? _searchList[index]
                            : _list[index]);
                  });
            } else {
              return const Center(
                child: Text('No Connections Found!',
                    style: TextStyle(fontSize: 20)),
              );
            }
          }
        },
      ),
    );
  }
}
