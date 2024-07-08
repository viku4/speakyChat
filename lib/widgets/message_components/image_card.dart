import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/screens/media_view_screen.dart';

import '../../helpers/my_date_util.dart';
import '../../model/message_model.dart';

class ImageMessage extends StatefulWidget {
  final String user2Name;
  final String fromPic;

  const ImageMessage(
      {super.key,
      required this.message,
      required this.user,
      required this.user2Name,
      required this.fromPic});

  final Message message;
  final ChatUser user;

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  String localImagePath = '';
  bool isBeingDownloaded = false;

  @override
  void initState() {
    super.initState();
    _initLocalImagePath();
  }

  Future<void> _initLocalImagePath() async {
    Directory? directory = await getExternalStorageDirectory();
    final isMe = APIService.user.uid == widget.message.fromId;
    final path = isMe
        ? '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Images/Sent/SpeakyChatIMG-${widget.message.sent}-${widget.message.fromId}.jpg'
        : '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Images/SpeakyChatIMG-${widget.message.sent}-${widget.message.fromId}.jpg';
    setState(() {
      localImagePath = path;
    });
  }

  Future<void> _downloadImage() async {

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
      final file = File(localImagePath);
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

  @override
  Widget build(BuildContext context) {
    bool isMe = APIService.user.uid == widget.message.fromId;
    return isMe ? _greenMessage() : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIService.updateMessageReadStatus(widget.message);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 135,
          maxHeight: 270,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xffffffff),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  if(!File(localImagePath).existsSync()){
                    return;
                  }
                  Get.to(() => MediaViewScreen(), arguments: [
                    widget.user,
                    true,
                    localImagePath,
                    MyDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent)
                  ]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: OverflowBox(
                        maxHeight:270,child: _buildImage()),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    if (widget.message.starred != null &&
                        widget.message.starred == "true")
                      Icon(
                        Icons.star_rate_outlined,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.black,
                        size: 15,
                      )
                    else
                      const SizedBox(),
                    if (widget.message.pinned != null && widget.message.pinned!)
                      Icon(
                        CupertinoIcons.pin,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.black,
                        size: 15,
                      )
                    else
                      const SizedBox(),
                    const SizedBox(width: 5),
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

  Widget _greenMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 135,
          maxHeight: 270,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xffffffff),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  if(!File(localImagePath).existsSync()){
                    return;
                  }
                  Get.to(() => MediaViewScreen(), arguments: [
                    APIService.user,
                    true,
                    localImagePath,
                    MyDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent)
                  ]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 3,
                    bottom: 3,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: OverflowBox(maxHeight: 270, child: _buildImage()),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Row(
                  children: [
                    if (widget.message.starred != null &&
                        widget.message.starred == "true")
                      Icon(
                        Icons.star_rate_outlined,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.grey,
                        size: 15,
                      )
                    else
                      const SizedBox(),
                    if (widget.message.pinned != null && widget.message.pinned!)
                      Icon(
                        CupertinoIcons.pin,
                        color: widget.message.type == Type.image
                            ? Colors.white
                            : Colors.grey,
                        size: 15,
                      )
                    else
                      const SizedBox(),
                    const SizedBox(width: 5),
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
                    const SizedBox(width: 5),
                    if (widget.message.isLocal != null)
                      const Icon(
                        Icons.timer,
                        size: 17,
                        color: Colors.white,
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
                    if (widget.message.isLocal == null &&
                        widget.message.read.isEmpty &&
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

  Widget _buildImage() {
    if (widget.message.isLocal != null && widget.message.isLocal) {
      // Display the local image
      return Stack(
        children: [
          Image.file(File(localImagePath),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width - 135),
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else if (File(localImagePath).existsSync()) {
      // Display the local image if it exists
      return Image.file(File(localImagePath),
          fit: BoxFit.cover, width: MediaQuery.of(context).size.width - 135);
    } else {
      // Download and display the image from the network
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: widget.message.msg,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
            imageBuilder: (context, imageProvider) => Container(
              height: 270,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
              ),
              child: Center(
                child: isBeingDownloaded ? CircularProgressIndicator(color: Colors.white,) : ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: _downloadImage,
                  child: const Icon(
                    Icons.download,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
