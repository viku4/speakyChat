import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:speaky_chat/api/api_services.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../model/message_model.dart';
import '../widgets/starred_message.dart';

class StarredMessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            size: 30.0,
          ),
          onPressed: () async {
            Get.back();
          },
        ),
        title: Text(
          'Starred Messages',
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: StreamBuilder<List<Message>>(
        stream: APIService.getStarredMessages(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return StarredMessageTile(message: message);
            },
          );
        },
      ),
    );
  }
}