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
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message, required this.user, required this.user2Name, required this.fromPic});

  final Message message;
  final ChatUser user;
  final String user2Name;
  final String fromPic;


  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIService.user.uid == widget.message.fromId;
    return isMe ? _greenMessage() : _blueMessage();
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
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 80,
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
                      color: Colors.grey[600],
                      size: 15,
                    )
                        : SizedBox(),

                    widget.message.pinned != null &&
                        widget.message.pinned!
                        ? Icon(
                      CupertinoIcons.pin,
                      color: Colors.grey[600],
                      size: 15,
                    )
                        : SizedBox(),
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
  }

  // our or user message
  Widget _greenMessage() {
    return Align(
      alignment: Alignment.centerRight,
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
                  right: widget.message.starred!=null && widget.message.starred=='true' ? 125 : 105,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  widget.message.msg,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Row(
                  children: [
                    widget.message.starred != null &&
                        widget.message.starred == "true"
                        ? Icon(
                      Icons.star_rate_outlined,
                      color: Colors.grey[600],
                      size: 15,
                    )
                        : SizedBox(

                    ),



                    widget.message.pinned != null &&
                        widget.message.pinned!
                        ? Icon(
                      CupertinoIcons.pin,
                      color: Colors.grey[600],
                      size: 15,
                    )
                        : SizedBox(),

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
                    SizedBox(
                      width: 5,
                    ),
                    if (widget.message.delivered.isNotEmpty && widget.message.read.isEmpty)
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.grey,
                      ),
                    if (widget.message.read.isNotEmpty)
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.green,
                      ),
                    if (widget.message.read.isEmpty && widget.message.delivered.isEmpty && widget.message.isLocal==null)
                      Icon(
                        Icons.done,
                        size: 20,
                        color: Colors.grey,
                      ),

                    if(widget.message.isLocal!=null)
                      const Icon(
                        Icons.timer,
                        size: 17,
                        color: Colors.grey,
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
    //     //message time
    //     Row(
    //       children: [
    //         //for adding some space
    //         SizedBox(width: MediaQuery.of(context).size.width * .04),
    //
    //         //double tick blue icon for message read
    //         if (widget.message.read.isNotEmpty)
    //           const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
    //
    //         //for adding some space
    //         const SizedBox(width: 2),
    //
    //         //sent time
    //         Text(
    //           MyDateUtil.getFormattedTime(
    //               context: context, time: widget.message.sent),
    //           style: const TextStyle(fontSize: 13, color: Colors.black54),
    //         ),
    //       ],
    //     ),
    //
    //     //message content
    //     Flexible(
    //       child: Container(
    //         padding: EdgeInsets.all(widget.message.type == Type.image
    //             ? MediaQuery.of(context).size.width * .03
    //             : MediaQuery.of(context).size.width * .04),
    //         margin: EdgeInsets.symmetric(
    //             horizontal: MediaQuery.of(context).size.width * .04, vertical: MediaQuery.of(context).size.height * .01),
    //         decoration: BoxDecoration(
    //             color: const Color.fromARGB(255, 218, 255, 176),
    //             border: Border.all(color: Colors.lightGreen),
    //             //making borders curved
    //             borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(30),
    //                 topRight: Radius.circular(30),
    //                 bottomLeft: Radius.circular(30))),
    //         child: widget.message.type == Type.text
    //             ?
    //         //show text
    //         Text(
    //           widget.message.msg,
    //           style: const TextStyle(fontSize: 15, color: Colors.black87),
    //         )
    //             :
    //         //show image
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(15),
    //           child: CachedNetworkImage(
    //             imageUrl: widget.message.msg,
    //             placeholder: (context, url) => const Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: CircularProgressIndicator(strokeWidth: 2),
    //             ),
    //             errorWidget: (context, url, error) =>
    //             const Icon(Icons.image, size: 70),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
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
