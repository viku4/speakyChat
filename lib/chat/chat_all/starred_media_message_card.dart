import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/screens/media_view_screen.dart';
// import 'package:voice_message_package/voice_message_package.dart';

import '../../helpers/my_date_util.dart';
import '../../model/message_model.dart';
// import 'package:gallery_saver/gallery_save?r.dart';

// for showing single message details
class StarredMediaMessage extends StatefulWidget {

  const StarredMediaMessage({super.key, required this.message});

  final Message message;

  @override
  State<StarredMediaMessage> createState() => _StarredMediaMessageState();
}

class _StarredMediaMessageState extends State<StarredMediaMessage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration();
  Duration position = Duration();
  bool playing = false;

  @override
  void initState() {
    super.initState();
  }

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
          maxWidth: MediaQuery.of(context).size.width - 135,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Color(0xffffffff),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              if (widget.message.type == Type.document)
                InkWell(
                  onTap: () {
                    // Get.to(() => MediaViewScreen(), arguments: [
                    //   widget.user,
                    //   false,
                    //   widget.message.msg.split('________')[1],
                    //   MyDateUtil.getFormattedTime(
                    //       context: context, time: widget.message.sent)
                    // ]);
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 9,
                        right: 9,
                        top: 9,
                        bottom: 9,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_present,
                            size: 35,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.message.msg.split('____')[1],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.message.msg
                                          .split('____')[1]
                                          .split('.')
                                          .last
                                          .toUpperCase() +
                                      " File",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),

              if (widget.message.type == Type.video)
                InkWell(
                  onTap: () {
                    // Get.to(() => MediaViewScreen(), arguments: [
                    //   widget.user,
                    //   false,
                    //   widget.message.msg.split('________')[1],
                    //   MyDateUtil.getFormattedTime(
                    //       context: context, time: widget.message.sent)
                    // ]);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 3,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg.split('____')[0],
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image, size: 70),
                          ),
                        ),
                        const Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 40,
                        )
                      ],
                    ),
                  ),
                ),

              if (widget.message.type == Type.image)
                InkWell(
                  onTap: () {
                    // Get.to(() => MediaViewScreen(), arguments: [
                    //   widget.user,
                    //   true,
                    //   widget.message.msg,
                    //   MyDateUtil.getFormattedTime(
                    //       context: context, time: widget.message.sent)
                    // ]);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 3,
                      right: 3,
                      top: 3,
                      bottom: 3,
                    ),
                    child: ClipRRect(
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
                ),

              if (widget.message.type == Type.audio)
                Padding(
                  padding: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: Container(
                    height: 55,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                        ),
                        InkWell(
                          onTap: () {
                            getAudio(widget.message.msg);
                          },
                          child: Icon(
                            playing
                                ? CupertinoIcons.pause
                                : CupertinoIcons.play,
                            color: Colors.black,
                          ),
                        ),
                        _slider()
                      ],
                    ),
                  ),
                ),

              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 3,
              //     right: 3,
              //     top: 3,
              //     bottom: 3,
              //   ),
              //   child: widget.message.type == Type.audio
              //       ? Container(
              //           height: 55,
              //           child: Row(
              //             children: [
              //               SizedBox(
              //                 width: 14,
              //               ),
              //               InkWell(
              //                 onTap: () {
              //                   getAudio(widget.message.msg);
              //                 },
              //                 child: Icon(
              //                   playing
              //                       ? CupertinoIcons.pause
              //                       : CupertinoIcons.play,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //               _slider()
              //             ],
              //           ),
              //         )
              //       : ClipRRect(
              //           borderRadius: BorderRadius.circular(15),
              //           child: CachedNetworkImage(
              //             imageUrl: widget.message.msg,
              //             placeholder: (context, url) => const Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: CircularProgressIndicator(strokeWidth: 2),
              //             ),
              //             errorWidget: (context, url, error) =>
              //                 const Icon(Icons.image, size: 70),
              //           ),
              //         ),
              // ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    widget.message.starred != null
                        ? Icon(
                      Icons.star_rate_outlined,
                      color: widget.message.type == Type.image
                          ? Colors.white
                          : Colors.black,
                      size: 15,
                    )
                        : SizedBox(),

                    widget.message.pinned != null
                        ? Icon(
                      CupertinoIcons.pin,
                      color: widget.message.type == Type.image
                          ? Colors.white
                          : Colors.black,
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
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.black,
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

  Widget _slider() {
    return Expanded(
      child: Slider.adaptive(
          min: 0.0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          activeColor: Colors.black,
          inactiveColor: Colors.black,
          allowedInteraction: SliderInteraction.tapAndSlide,
          onChanged: (double value) {
            setState(() {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            });
          }),
    );
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
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .015,
                    horizontal: MediaQuery.of(context).size.width * .4),
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
                    // APIService.pinMessage(userData['msg'] ?? '',isMe ? widget.message.toId : widget.message.fromId, widget.message.sent, widget.message);
                  }),
              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          // Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save option
                  // _OptionItem(
                  //     icon: const Icon(Icons.download_rounded,
                  //         color: Colors.blue, size: 26),
                  //     name: 'Save Image',
                  //     onTap: () async {
                  //       try {
                  //         log('Image Url: ${widget.message.msg}');
                  //         await GallerySaver.saveImage(widget.message.msg,
                  //             albumName: 'We Chat')
                  //             .then((success) {
                  //           //for hiding bottom sheet
                  //           Navigator.pop(context);
                  //           if (success != null && success) {
                  //             Dialogs.showSnackbar(
                  //                 context, 'Image Successfully Saved!');
                  //           }
                  //         });
                  //       } catch (e) {
                  //         log('ErrorWhileSavingImg: $e');
                  //       }
                  //     }),

                  const SizedBox(
                      height: 1,
                    ),
              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: MediaQuery.of(context).size.width * .04,
                  indent: MediaQuery.of(context).size.width * .04,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
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
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
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
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
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
                      style: TextStyle(color: Colors.blue, fontSize: 16),
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
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }

  Future<void> getAudio(String url) async {
    if (playing) {
      await audioPlayer.pause();
      setState(() {
        playing = false;
      });
    } else {
      var res = await audioPlayer.play(UrlSource(url));
      setState(() {
        playing = true;
        // audioPlayer.play();
      });
    }
    // audioPlayer!.onD
    duration = (await audioPlayer.getDuration())!;
    // audioPlayer.onDurationChanged.listen((Duration d) {
    //   setState(() {
    //     duration = d;
    //   });
    // });

    audioPlayer.onPositionChanged.listen((Duration d) {
      setState(() {
        position = d;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) async {
      Duration? d = await audioPlayer.getCurrentPosition();
      audioPlayer.seek(Duration.zero);
      Fluttertoast.showToast(msg: 'msg $d');
      setState(() {
        // position = 0.0;
        playing = false;
      });
    });
  }

  String? getThumbnail(String msg) {
    final data = jsonDecode(msg);
    if (data is Map<String, dynamic>) {
      return data["thumb"] as String? ?? ""; // Handle potential null value
    }
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
