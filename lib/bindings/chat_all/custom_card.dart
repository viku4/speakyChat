import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:socket_io_client/socket_io_client.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/chat/chat_detail/chat_detail_widget.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../helpers/my_date_util.dart';
import '../../model/chat_model.dart';
import '../../model/chat_user.dart';
import '../../model/message_model.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key, required this.user}) : super(key: key);

  // CustomCard({Key? key, this.chatModel, this.sourchat, this.socket}) : super(key: key);
  // final ChatModel? chatModel;
  // final ChatModel? sourchat;
  // IO.Socket? socket;

  final ChatUser user;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  Message? _message;
  String profilePic = '';


  @override
  void initState() {
    super.initState();
    _getProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // connectToSocket();
        Get.to(() => ChatDetailWidget(), arguments: [
          widget.user,
          profilePic
        ]);

        //

        // Get.to(() => ChatDetailWidget(), arguments: [
        //   widget.user.image,
        //   widget.user.name,
        //   FirebaseAuth.instance.currentUser!.uid,
        //   widget.user.id,
        //   // socket
        // ]);

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (contex) => ChatDetailWidget(
        //         chatId: chatModel!.id,
        //         // chatModel: chatModel,
        //         sourceChat: sourchat,
        //       ),
        //     ));

      },
      child: Column(
        children: [
          StreamBuilder(
              stream: APIService.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.blueGrey[200],
                    child: widget.user.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.red,
                                      ))),
                              imageUrl: profilePic != ''? profilePic :widget.user.image,
                            ))
                        : SvgPicture.asset(
                            "assets/person.svg",
                            color: Colors.white,
                            height: 30,
                            width: 30,
                          ),
                  ),
                  title: Text(
                    widget.user.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.done_all, size: 17),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                          _message != null
                              ? _message!.type == Type.image
                                  ? 'image'
                                  : _message!.msg
                              : widget.user.about,
                          maxLines: 1),
                    ],
                  ),
                  trailing: Text(
                    MyDateUtil.getLastMessageTime(
                        context: context, time: _message!.sent),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Future<void> _getProfilePic() async {
    profilePic = await APIService.getProfilePic(widget.user.id);
    setState(() {

    });
  }

  // void connectToSocket() {
  //   socket = IO.io("https://speaky.onrender.com",
  //       OptionBuilder().setTransports(['websocket']).build());
  //
  //   socket!.emit("signin", FirebaseAuth.instance.currentUser!.uid);
  //   socket!.connect();
  //
  //   socket!.onConnect((data) {
  //     debugPrint("Connected");
  //   });
  // }
}
