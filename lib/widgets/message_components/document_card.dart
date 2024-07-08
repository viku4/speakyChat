import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speaky_chat/api/api_services.dart';
import 'package:speaky_chat/model/chat_user.dart';
// import 'package:voice_message_package/voice_message_package.dart';

import '../../helpers/my_date_util.dart';
import '../../model/message_model.dart';

class DocumentMessage extends StatefulWidget {
  final String user2Name;
  final String fromPic;

  const DocumentMessage(
      {super.key,
      required this.message,
      required this.user,
      required this.user2Name,
      required this.fromPic});

  final Message message;
  final ChatUser user;

  @override
  State<DocumentMessage> createState() => _DocumentMessageState();
}

class _DocumentMessageState extends State<DocumentMessage> {
  String localDocumentPath = '';
  bool isBeingDownloaded = false;

  @override
  void initState() {
    super.initState();
    _initLocalDocumentPath();
  }

  Future<void> _initLocalDocumentPath() async {
    Directory? directory = await getExternalStorageDirectory();
    final isMe = APIService.user.uid == widget.message.fromId;
    final fileName = widget.message.msg.split('____')[1];
    final path = isMe
        ? '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Documents/Sent/$fileName'
        : '${directory!.parent.parent.parent.parent.path}/SpeakyChat/Media/SpeakyChat Documents/$fileName';
    setState(() {
      localDocumentPath = path;
    });
  }


  Future<void> _downloadDocument() async {
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
      final file = File(localDocumentPath);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      setState(() {
        isBeingDownloaded = false;
      });
    } catch (e) {
      setState(() {
        isBeingDownloaded = false;
      });
      print('Error creating directory or downloading document: $e');
    }
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
          color: const Color(0xffffffff),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              InkWell(
                onTap: () async {
                  if (!File(localDocumentPath).existsSync()) {
                    _downloadDocument();
                    return;
                  }
                  await OpenFile.open(localDocumentPath);
                },
                child: _buildDocument(
                    widget.message.msg.split('____')[1].split('.').last),
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
                  if (!File(localDocumentPath).existsSync()) {
                    _downloadDocument();
                    return;
                  }
                  OpenFile.open(localDocumentPath);
                },
                child: _buildDocument(
                    widget.message.msg.split('____')[1].split('.').last),
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
                    if (widget.message.isLocal != null)
                      const Icon(
                        Icons.timer,
                        size: 17,
                        color: Colors.black,
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

  Widget _buildDocument(String ext) {
    if (widget.message.isLocal != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
            child: Container(
              height: 60,
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ext.toUpperCase() == "PDF")
                    Image.asset(
                      'assets/icons/pdf.png',
                      width: 30,
                    ),
                  if (ext.toUpperCase() == "XLSX")
                    Image.asset(
                      'assets/icons/xlsx.png',
                      width: 30,
                    ),
                  if (ext.toUpperCase().length == 3 &&
                      ext.toUpperCase() != "PDF")
                    Stack(children: [
                      Image.asset(
                        'assets/icons/default.png',
                        width: 35,
                      ),
                      Positioned(
                          left: 7.3,
                          top: 12.3,
                          child: Text(
                            ext.toUpperCase(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 10.5),
                          ))
                    ]),
                  if (ext.toUpperCase().length == 4 &&
                      ext.toUpperCase() != "XLSX")
                    Stack(children: [
                      Image.asset(
                        'assets/icons/default.png',
                        width: 30,
                      ),
                      Positioned(
                          left: 5.8,
                          top: 12,
                          child: Text(
                            ext.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 8),
                          ))
                    ]),
                  if (ext.toUpperCase().length != 4 &&
                      ext.toUpperCase().length != 3)
                    const Icon(
                      Icons.file_present,
                      size: 39,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      widget.message.msg.split('____')[1],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            height: 2.5,
            color: Colors.black,
          ),
          Container(
            height: 25,
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.message.msg
                          .split('____')[1]
                          .split('.')
                          .last
                          .toUpperCase() +
                      " File",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      );
    } else if (File(localDocumentPath).existsSync()) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
            child: Container(
              height: 60,
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ext.toUpperCase() == "PDF")
                    Image.asset(
                      'assets/icons/pdf.png',
                      width: 30,
                    ),
                  if (ext.toUpperCase() == "XLSX")
                    Image.asset(
                      'assets/icons/xlsx.png',
                      width: 30,
                    ),
                  if (ext.toUpperCase().length == 3 &&
                      ext.toUpperCase() != "PDF")
                    Stack(children: [
                      Image.asset(
                        'assets/icons/default.png',
                        width: 35,
                      ),
                      Positioned(
                          left: 7.3,
                          top: 12.3,
                          child: Text(
                            ext.toUpperCase(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 10.5),
                          ))
                    ]),
                  if (ext.toUpperCase().length == 4 &&
                      ext.toUpperCase() != "XLSX")
                    Stack(children: [
                      Image.asset(
                        'assets/icons/default.png',
                        width: 30,
                      ),
                      Positioned(
                          left: 5.8,
                          top: 12,
                          child: Text(
                            ext.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 8),
                          ))
                    ]),
                  if (ext.toUpperCase().length != 4 &&
                      ext.toUpperCase().length != 3)
                    const Icon(
                      Icons.file_present,
                      size: 39,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      widget.message.msg.split('____')[1],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 2.5,
            color: Colors.black,
          ),
          Container(
            height: 25,
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.message.msg
                          .split('____')[1]
                          .split('.')
                          .last
                          .toUpperCase() +
                      " File",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
            child: Container(
              height: 60,
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ext.toUpperCase() == "PDF")
                    Image.asset(
                      'assets/icons/pdf.png',
                      width: 30,
                    ),
                  if (ext.toUpperCase() == "XLSX")
                    Image.asset(
                      'assets/icons/xlsx.png',
                      width: 30,
                    ),
                  if (ext.toUpperCase().length == 3 &&
                      ext.toUpperCase() != "PDF")
                    Stack(children: [
                      Image.asset(
                        'assets/icons/default.png',
                        width: 35,
                      ),
                      Positioned(
                          left: 7.3,
                          top: 12.3,
                          child: Text(
                            ext.toUpperCase(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 10.5),
                          ))
                    ]),
                  if (ext.toUpperCase().length == 4 &&
                      ext.toUpperCase() != "XLSX")
                    Stack(children: [
                      Image.asset(
                        'assets/icons/default.png',
                        width: 30,
                      ),
                      Positioned(
                          left: 5.8,
                          top: 12,
                          child: Text(
                            ext.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 8),
                          ))
                    ]),
                  if (ext.toUpperCase().length != 4 &&
                      ext.toUpperCase().length != 3)
                    const Icon(
                      Icons.file_present,
                      size: 39,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(
                      widget.message.msg.split('____')[1],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: isBeingDownloaded
                        ? const SizedBox(
                      width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                        )
                        : const Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            height: 2.5,
            color: Colors.black,
          ),
          Container(
            height: 25,
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.message.msg
                          .split('____')[1]
                          .split('.')
                          .last
                          .toUpperCase() +
                      " File",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      );
    }
  }
}