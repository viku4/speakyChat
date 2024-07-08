import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/screens/media_view_screen.dart';
import 'package:speaky_chat/screens/view_contact.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:voice_message_package/voice_message_package.dart';

import '../../helpers/my_date_util.dart';
import '../../model/message_model.dart';

class AudioMessage extends StatefulWidget {
  final String user2Name;

  final String fromPic;

  const AudioMessage(
      {super.key,
      required this.message,
      required this.user,
      required this.user2Name,
      required this.fromPic});

  final Message message;
  final ChatUser user;

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool playing = false;
  String localAudioPath = '';
  bool isBeingDownloaded = false;

  @override
  void initState() {
    super.initState();
    _initLocalAudioPath();
  }

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
          color: const Color(0xffffffff),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              _buildAudioPlayer(widget.message.msg),
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
                                : Colors.black,
                            size: 15,
                          )
                        : const SizedBox(),
                    widget.message.pinned != null && widget.message.pinned!
                        ? Icon(
                            CupertinoIcons.pin,
                            color: widget.message.type == Type.image
                                ? Colors.white
                                : Colors.black,
                            size: 15,
                          )
                        : const SizedBox(),
                    const SizedBox(
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
  }

  // our or user message
  Widget _greenMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 135,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xffffffff),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              _buildAudioPlayer(widget.message.msg),
              Positioned(
                bottom: 4,
                right: 8,
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
                        : const SizedBox(),
                    widget.message.pinned != null && widget.message.pinned!
                        ? Icon(
                            CupertinoIcons.pin,
                            color: widget.message.type == Type.image
                                ? Colors.white
                                : Colors.grey,
                            size: 15,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      MyDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (widget.message.delivered.isNotEmpty &&
                        widget.message.read.isEmpty)
                      const Icon(
                        Icons.done_all,
                        size: 20,
                      ),
                    if (widget.message.read.isNotEmpty)
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.green,
                      ),
                    if (widget.message.read.isEmpty &&
                        widget.message.delivered.isEmpty)
                      const Icon(
                        Icons.done,
                        size: 20,
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

  Future<void> getAudio(String filePath) async {
    if (playing) {
      await audioPlayer.pause();
      setState(() {
        playing = false;
      });
    } else {
      var res = await audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        playing = true;
      });
    }

    duration = (await audioPlayer.getDuration())!;

    audioPlayer.onPositionChanged.listen((Duration d) {
      setState(() {
        position = d;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) async {
      Duration? d = await audioPlayer.getCurrentPosition();
      audioPlayer.seek(Duration.zero);
      Fluttertoast.showToast(msg: 'Audio playback complete. Position: $d');
      setState(() {
        playing = false;
      });
    });
  }


  Future<void> _initLocalAudioPath() async {
    Directory? directory = await getExternalStorageDirectory();
    String ext = widget.message.msg
        .split('googleapis.com')[1]
        .split('?alt')[0]
        .split('.')
        .last;
    final isMe = APIService.user.uid == widget.message.fromId;
    final path = isMe
        ? '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Audios/Sent/SpeakyChatAUD-${widget.message.sent}-${widget.message.fromId}.$ext'
        : '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Audios/SpeakyChatAUD-${widget.message.sent}-${widget.message.fromId}.$ext';
    setState(() {
      localAudioPath = path;
    });
  }

  Future<void> _downloadAudio() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Network not connected');
      return;
    }
    try {
      setState(() {
        isBeingDownloaded = true;
      });
      final directory = Directory('/storage/emulated/0/SpeakyChat');
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final response =
          await NetworkAssetBundle(Uri.parse(widget.message.msg)).load("");
      final bytes = response.buffer.asUint8List();
      final file = File(localAudioPath);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      setState(() {
        isBeingDownloaded = false;
      });
    } catch (e) {
      setState(() {
        isBeingDownloaded = false;
      });
      print('Error creating directory or downloading image: $e');
    }
  }

  Widget _buildAudioPlayer(String msg) {
    if (widget.message.isLocal != null) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 3,
          right: 3,
          top: 3,
          bottom: 3,
        ),
        child: SizedBox(
          height: 55,
          child: Row(
            children: [
              const SizedBox(
                width: 19,
              ),
              SizedBox(width: 19, height:19,child: CircularProgressIndicator(color: Colors.black)),
              // InkWell(
              //   onTap: () {
              //     getAudio(msg);
              //   },
              //   child: Icon(
              //     playing ? CupertinoIcons.pause : CupertinoIcons.play,
              //     color: Colors.black,
              //   ),
              // ),
              _slider()
            ],
          ),
        ),
      );
    } else if (File(localAudioPath).existsSync()) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 3,
          right: 3,
          top: 3,
          bottom: 3,
        ),
        child: SizedBox(
          height: 55,
          child: Row(
            children: [
              const SizedBox(
                width: 14,
              ),
              InkWell(
                onTap: () {
                  getAudio(localAudioPath);
                },
                child: Icon(
                  playing ? CupertinoIcons.pause : CupertinoIcons.play,
                  color: Colors.black,
                ),
              ),
              _slider()
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
          left: 3,
          right: 3,
          top: 3,
          bottom: 3,
        ),
        child: SizedBox(
          height: 55,
          child: Row(
            children: [
              const SizedBox(
                width: 14,
              ),
              isBeingDownloaded ? SizedBox(width:19, height:19,child: CircularProgressIndicator()) : InkWell(
                onTap: () {
                  _downloadAudio();
                },
                child: Icon(Icons.download, color: Colors.black,)
              ),
              _slider()
            ],
          ),
        ),
      );
    }
  }
}
