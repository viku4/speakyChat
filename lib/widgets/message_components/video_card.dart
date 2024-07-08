import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/model/chat_user.dart';
import 'package:speaky_chat/screens/media_view_screen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../helpers/my_date_util.dart';
import '../../model/message_model.dart';

// for showing single message details
class VideoMessage extends StatefulWidget {
  final String user2Name;

  final String fromPic;

  const VideoMessage(
      {super.key,
      required this.message,
      required this.user,
      required this.user2Name,
      required this.fromPic});

  final Message message;
  final ChatUser user;

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  String localVideoPath = '';
  bool isBeingDownloaded = false;
  String thumbnail = '';

  @override
  void initState() {
    super.initState();
    _initLocalVideoPath();
  }

  Future<void> _initLocalVideoPath() async {
    Directory? directory = await getExternalStorageDirectory();
    final isMe = APIService.user.uid == widget.message.fromId;
    String videoPath = widget.message.msg.split('________')[1];
    String ext =
        videoPath.split('googleapis.com')[1].split('?alt')[0].split('.').last;

    final path = isMe
        ? '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Videos/Sent/SpeakyChatVID-${widget.message.sent}-${widget.message.fromId}.$ext'
        : '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Videos/SpeakyChatVID-${widget.message.sent}-${widget.message.fromId}.$ext';

    localVideoPath = path;

    final thumbnailFile = await VideoCompress.getFileThumbnail(path,
        quality: 50, // default(100)
        position: -1 // default(-1)
        );

    setState(() {
      thumbnail = thumbnailFile.path;
    });
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
          maxHeight: 270,
        ),
        child: Card(elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: const Color(0xffffffff),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  if(!File(localVideoPath).existsSync()){
                    return;
                  }
                  Get.to(() => MediaViewScreen(), arguments: [
                    widget.user,
                    false,
                    localVideoPath,
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
                      maxHeight: 270,
                      child: _buildThumbail(),
                    ),
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
                  if(!File(localVideoPath).existsSync()){
                    return;
                  }
                  Get.to(() => MediaViewScreen(), arguments: [
                    APIService.me,
                    false,
                    localVideoPath,
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
                        maxHeight: 270,
                        child: _buildThumbail(),
                      )),
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
                        widget.message.delivered.isEmpty && widget.message.isLocal==null)
                      const Icon(
                        Icons.done,
                        size: 20,
                        color: Colors.grey,
                      ),

                    if (widget.message.isLocal!=null)
                      const Icon(
                        Icons.timer,
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

  _buildThumbail() {
    if (widget.message.isLocal != null) {
      return Stack(
        children: [
          Container(
            child: Image.file(File(thumbnail),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 135),
          ),
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else if (File(localVideoPath).existsSync()) {
      return Stack(
        children: [
          Container(
            child: Image.file(File(thumbnail),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 135),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.message.msg.split('____')[0],
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
            ),
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.image, size: 70),
          ),
          Center(
            child: isBeingDownloaded
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: _downloadVideo,
                    child: const Icon(
                      Icons.download,
                      color: Colors.black,
                    ),
                  ),
          )
        ],
      );
    }
  }

  void _downloadVideo() async {
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

      final response = await NetworkAssetBundle(
              Uri.parse(widget.message.msg.split('________')[1]))
          .load("");
      final bytes = response.buffer.asUint8List();
      final file = File(localVideoPath);
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

  Future<String?> _generateThumbnail(String videoPath) async {
    try {
      // await _requestPermission();
      final String? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 270,
        // Specify the height of the thumbnail
        quality: 75,
      );
      return thumbnailPath;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }
}
