import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/chat/chat_detail/chat_detail_widget.dart';

import '../../helpers/my_date_util.dart';
import '../../model/chat_user.dart';
import '../../model/message_model.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;
  String name = '';
  String profilePic = '';

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
    _getProfilePic();
    // if(widget.user.name==''){
    //   fetchName();
    // }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      color: Colors.black,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            //for navigating to chat screen

            Get.to(() => ChatDetailWidget(),
                arguments: [widget.user, profilePic]);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => ChatDetailWidget(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIService.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _message = list[0];
                _updateDelivered();
                // print(_message);
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .03),
                      child: InkWell(
                        onTap: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (_) => ProfileDialog(user: widget.user));
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: mq.height * .055,
                          height: mq.height * .055,
                          imageUrl:
                              profilePic != '' ? profilePic : widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name != ''
                                ? widget.user.name
                                : name != ''
                                    ? name
                                    : widget.user.phone,
                            // widget.user.name != '' ? widget.user.name : name,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              if (_message != null &&
                                  _message!.delivered != '' &&
                                  _message!.read == '' &&
                                  _message!.fromId == APIService.user.uid)
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.done_all,
                                    size: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                              if (_message != null &&
                                  _message!.read != '' &&
                                  _message!.fromId == APIService.user.uid)
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.done_all,
                                    size: 17,
                                    color: Colors.green,
                                  ),
                                ),
                              if (_message != null &&
                                  _message!.read == '' &&
                                  _message!.delivered == '' &&
                                  _message!.fromId == APIService.user.uid)
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              // Text(_message!.read),

                              if (_message != null &&
                                  _message!.type == Type.document)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.file_present,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.location)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.location_on,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.contact)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.audio)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.headphones,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.image)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.image,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.video)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.local_movies,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.document)
                                Expanded(
                                  child: Text(
                                    _message!.msg.split('____')[1],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.location)
                                Expanded(
                                  child: Text(
                                    'Location',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.contact)
                                Expanded(
                                  child: Text(
                                    _message!.msg.split(';')[0],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.audio)
                                Expanded(
                                  child: Text(
                                    'Audio',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.image)
                                Expanded(
                                  child: Text(
                                    'Photo',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),

                              if (_message != null &&
                                  _message!.type == Type.video)
                                Expanded(
                                  child: Text(
                                    'Video',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),
                              if (_message != null &&
                                  _message!.type == Type.text)
                                Expanded(
                                  child: Text(
                                    _message!.msg,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xb3ffffff)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_message != null)
                          Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.white),
                          ),
                        if (_message != null &&
                            _message!.read.isEmpty &&
                            _message!.fromId != APIService.user.uid)
                          SizedBox(
                            height: 7,
                          ),
                        if (_message != null &&
                            _message!.read.isEmpty &&
                            _message!.fromId != APIService.user.uid)
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          )
                      ],
                    )
                  ],
                ),
              );
              // return ListTile(
              //
              //   //last message time
              //   trailing:
              //
              //       :
              //   //message sent time
              //
              // );
            },
          )),
    );
  }

  Future<void> fetchName() async {
    try {
      // Fetch contacts
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);
      // Iterate through contacts
      for (Contact contact in contacts) {
        // Iterate through phone numbers of each contact
        // Fluttertoast.showToast(msg: 'msg');
        for (Phone phone in contact.phones ?? []) {
          String contactPhoneNumber = phone.number!;
          // Remove any whitespace or non-numeric characters
          contactPhoneNumber = contactPhoneNumber.replaceAll(RegExp(r'\D'), '');
          // Check for exact match or matches with "+91" or "0" prefixes
          if (contactPhoneNumber == widget.user.phone ||
              "+91$contactPhoneNumber" == widget.user.phone ||
              "0$contactPhoneNumber" == widget.user.phone) {
            setState(() {
              name = contact.displayName ?? "";
            });
            APIService.updateNameInFirestore(widget.user.id, name);
            return; // Exit function after finding a match
          }
        }
      }
      // If no match is found
      setState(() {
        name = ""; // or any other appropriate value
      });
    } catch (e) {
      // Handle any errors
      print("Error fetching contacts: $e");
    }
  }

  Future<void> _requestContactsPermission() async {
    if (await Permission.contacts.request().isGranted) {
      print('${widget.user.name} && ${widget.user.name.length}');
      if (widget.user.name.isEmpty) {
        fetchName();
      }
    } else {
      // Handle permission denied
      // For simplicity, you can display an error message
      print('Permission denied');
    }
  }

  void _updateDelivered() {
    if (_message != null &&
        _message!.delivered == '' &&
        _message!.fromId != APIService.user.uid) {
      APIService.updateMessageDeliveryStatus(_message!);
    }
    // print(abc);
  }

  Future<void> _getProfilePic() async {
    profilePic = await APIService.getProfilePic(widget.user.id);
    setState(() {});
  }
}

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: mq.height * .075,
                left: mq.width * .1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .25),
                  child: CachedNetworkImage(
                    width: mq.width * .5,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              //user name
              Positioned(
                left: mq.width * .04,
                top: mq.height * .02,
                width: mq.width * .55,
                child: Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => ViewProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}
