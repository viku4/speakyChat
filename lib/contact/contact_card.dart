import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:socket_io_client/socket_io_client.dart';

import '../api/api_services.dart';
import '../chat/chat_detail/chat_detail_widget.dart';
import '../model/chat_model.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/chat_user.dart';

class ContactCard extends StatefulWidget {
  final ChatUser user;

  ContactCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {

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

        print(widget.user.image);
        Get.to(() => ChatDetailWidget(), arguments: [
          widget.user,
          profilePic
        ]);
      },
      child: ListTile(
        leading: Container(
          width: 50,
          height: 53,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.blueGrey[200],
                child: widget.user.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          height: 65,
                          width: 65,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.red,
                                  ))),
                          imageUrl: profilePic!='' ? profilePic :widget.user.image,
                        ))
                    : SvgPicture.asset(
                        "assets/person.svg",
                        color: Colors.white,
                        height: 30,
                        width: 30,
                      ),
              ),
              // contact!.select!
              //     ? Positioned(
              //         bottom: 4,
              //         right: 5,
              //         child: CircleAvatar(
              //           backgroundColor: Colors.teal,
              //           radius: 11,
              //           child: Icon(
              //             Icons.check,
              //             color: Colors.white,
              //             size: 18,
              //           ),
              //         ),
              //       )
              //     : Container(),
            ],
          ),
        ),
        title: Text(
          widget.user.name,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          widget.user.about,
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
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
