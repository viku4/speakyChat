import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speaky_chat/chat/chat_all/starred_media_message_card.dart';
import 'package:speaky_chat/chat/chat_all/starred_message_card.dart';

import '../chat/chat_all/media_message_card.dart';
import '../chat/chat_all/message_card.dart';
import '../helpers/my_date_util.dart';
import '../model/message_model.dart';

class StarredMessageTile extends StatelessWidget {
  final Message message;

  StarredMessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 30,),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 30,
                    height: 30,
                    imageUrl: message.fromPic!,
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(
                        child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Text(message.fromName!, style: TextStyle(color: Colors.white, fontSize: 18),),
              SizedBox(width: 3,),
              Icon(Icons.arrow_right, color: Colors.grey,),
              SizedBox(width: 3,),
              Text(message.toName!, style: TextStyle(color: Colors.white, fontSize: 18),),
              Expanded(child: SizedBox()),
              Text(
                MyDateUtil.getLastMessageTime(
                    context: context, time: message.sent),
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(width: 30,)
            ],
          ),
          SizedBox(height: 10,),

      Row(
        children: [
          SizedBox(width: 15,),
          message.type == Type.text ? StarredMessageCard(
            message: message,
          ) : StarredMediaMessage(
            message: message,
          ),
        ],
      ),
          // message.type == Type.text
          //     ? StarredMessageCard(
          //   message: message,
          // )
          //     : MediaMessage(
          //   key: itemKeys[index],
          //   message: cont.list[index],
          //   user: cont.user,
          //   user2Name: cont.nickname.value,
          //   fromPic: cont.profilePic.value,
          // );
          SizedBox(height: 10),
          Divider()
        ],
      ),
    );
    // return ListTile(
    //   // TODO: Display chat user name/avatar based on message.fromId
    //   title: Text(message.msg),
    //   subtitle: Text(DateTime.fromMillisecondsSinceEpoch(int.parse(message.sent)).toString()),
    //   trailing: Icon(Icons.star), // Or a custom star icon
    // );
  }
}