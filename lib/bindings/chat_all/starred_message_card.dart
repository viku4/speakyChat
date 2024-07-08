import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speaky_chat/api/api_services.dart';

import '../../helpers/my_date_util.dart';
import '../../model/chat_user.dart';
import '../../model/message_model.dart';
// import 'package:gallery_saver/gallery_save?r.dart';

// for showing single message details
class StarredMessageCard extends StatefulWidget {
  const StarredMessageCard({super.key, required this.message});

  final Message message;


  @override
  State<StarredMessageCard> createState() => _StarredMessageCardState();
}

class _StarredMessageCardState extends State<StarredMessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIService.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIService.updateMessageReadStatus(widget.message);
    }

    var mq = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Color(0xffffffff),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: widget.message.starred != null &&
                      widget.message.starred == "true" ? 90 :80,
                  top: 8,
                  bottom: 8,
                ),
                child: widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image, size: 70),
                        ),
                      ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    widget.message.starred != null &&
                        widget.message.starred == "true"
                        ? Icon(
                      Icons.star_rate_outlined,
                      color: widget.message.type == Type.image
                          ? Colors.white
                          : Colors.grey,
                      size: 15,
                    )
                        : SizedBox(

                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     //message content
    //     Flexible(
    //       child: Container(
    //         padding: EdgeInsets.all(widget.message.type == Type.image
    //             ? mq.width * .03
    //             : mq.width * .04),
    //         margin: EdgeInsets.symmetric(
    //             horizontal: mq.width * .04, vertical: mq.height * .01),
    //         decoration: BoxDecoration(
    //             color: const Color.fromARGB(255, 221, 245, 255),
    //             border: Border.all(color: Colors.lightBlue),
    //             //making borders curved
    //             borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(30),
    //                 topRight: Radius.circular(30),
    //                 bottomRight: Radius.circular(30))),
    //         child: widget.message.type == Type.text
    //             ?
    //             //show text
    //             Text(
    //                 widget.message.msg,
    //                 style: const TextStyle(fontSize: 15, color: Colors.black87),
    //               )
    //             :
    //             //show image
    //             ClipRRect(
    //                 borderRadius: BorderRadius.circular(15),
    //                 child: CachedNetworkImage(
    //                   imageUrl: widget.message.msg,
    //                   placeholder: (context, url) => const Padding(
    //                     padding: EdgeInsets.all(8.0),
    //                     child: CircularProgressIndicator(strokeWidth: 2),
    //                   ),
    //                   errorWidget: (context, url, error) =>
    //                       const Icon(Icons.image, size: 70),
    //                 ),
    //               ),
    //       ),
    //     ),
    //
    //     //message time
    //     Padding(
    //       padding: EdgeInsets.only(right: mq.width * .04),
    //       child: Text(
    //         MyDateUtil.getFormattedTime(
    //             context: context, time: widget.message.sent),
    //         style: const TextStyle(fontSize: 13, color: Colors.black54),
    //       ),
    //     ),
    //   ],
    // );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        backgroundColor: Colors.black,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                padding: EdgeInsets.only(top: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(
                        bottom: BorderSide.none,
                        top: BorderSide(color: Colors.white))),
              ),
              Container(
                height: 3,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .015,
                    horizontal: MediaQuery.of(context).size.width * .44),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              _OptionItem(
                  icon: const Icon(CupertinoIcons.pin,
                      color: Colors.white, size: 26),
                  name: 'Pin Message',
                  onTap: () async {
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    Stream userData = await APIService.listenForData(isMe ? widget.message.toId : widget.message.fromId);
                  print(userData);
                    // APIService.pinMessage(userData['sent'] ?? '', isMe ? widget.message.toId : widget.message.fromId, widget.message.sent, widget.message);
                  }),

              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIService.deleteMessage(widget.message)
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.grey,
                endIndent: MediaQuery.of(context).size.width * .04,
                indent: MediaQuery.of(context).size.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.check, color: Colors.white),
                  name:
                      'Sent : ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.done_all, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read : Not seen yet'
                      : 'Read : ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.black,
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    ' Edit Message',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                style: TextStyle(color: Colors.white),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIService.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .05,
              top: MediaQuery.of(context).size.height * .015,
              bottom: MediaQuery.of(context).size.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15, color: Colors.white, letterSpacing: 0.5)))
          ]),
        ));
  }
}
